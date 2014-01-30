class Navigation < RoutingFilter::Filter
  include ActionDispatch::Routing::UrlFor
  include ActionDispatch::Routing::Redirection

  def around_recognize(path, env, &block)
    self.class_eval{ include Rails.application.routes.url_helpers }

    # We're not going to do this twice for the same request also
    # do not look for nav items if this is a request for an asset.
    yield if defined? env['ORIGINAL_PATH_INFO']

    yield if path =~ /^\/assets/ and return

    # We need a copy of the original path because the alteration is done in place.
    env['ORIGINAL_PATH_INFO'] = path.clone

    # Get the path without the leading slash.
    local_path = path.sub(/^\//, '')

    unless local_path.blank?
      item = Trim::NavItem.find_active_by( local_path )

      unless item.blank?
        set_rails_path_for_linked_nav_item(item, path) if item.is_linked? && !item.linked.blank?
        set_rails_path_for_route_nav_item(item, path) if item.is_route? && !item.route.blank?
      end
    end
  end

  def around_generate(params, &block)
    self.class_eval{ include Rails.application.routes.url_helpers }

    # This provides us with a way to disable our navigation filter.
    use_navigation = !(params.delete(:navigation_filter) === false)

    if use_navigation
      # Alter arguments to url_for.
      record = get_record_from_params params
      navigation_path = get_outgoing_path_for record, params

      if navigation_path.is_a?(Hash)
        params.replace navigation_path
      elsif navigation_path.is_a?(String)
        # This is a funny hack to make sure we don't throw routing errors
        # when we know what path we want to use.
        params.replace({ :controller => '/home', :action => 'index' })
      end
    end

    if use_navigation && !navigation_path.blank?
      yield.tap do |result|
        # Modify path after url_for.
        url = result.is_a?(Array) ? result.first : result

        if navigation_path.is_a?(String)
          url.replace navigation_path
        elsif !params.blank? && %w(index show).include?(params[:action])
          # This replacement prevents routes from picking up params from the
          # current request. We're whitelisting index and show at the moment.
          url.replace url_for(params.merge(:only_path => true, :navigation_filter => false))
        end
      end
    else
      yield
    end
  end

  protected


  def set_rails_path_for_linked_nav_item(item, path)
    # Passing the :navigation_filter parameter disables our custom generate below.
    # We have to modify the string in place, or it doesn't affect subsequent wrappers.

    canonical = item.find_canonical_by_nav_item
    path.replace polymorphic_path(canonical.linked, :navigation_filter => false)
  end

  def set_rails_path_for_route_nav_item(item, path)
    path.replace "/#{item.route}"
  end

  def get_record_from_params(params)
    record = params[:id]

    # If there's no id, we want the first passed that's a record.
    if record.nil?
      params.each do |key, value|
        return value if value.is_a? ActiveRecord::Base
      end
    end

    if record.is_a? Integer
      model = params[:controller].classify.constantize
      record = model.find record
    end
    record
  end

  def get_outgoing_path_for(record, params)
    # Try to get a path from other models.
    if record.respond_to? :navigation_arguments
      # When our action is 'new' we shouldn't be passing in an id.
      args = (params[:action] == 'new') ? record.parent_navigation_arguments : record.navigation_arguments
      return params.merge(args)
    end

    if record.is_a?(Trim::NavItem)
      record = Trim::NavItem.find_active_by( record )
    else
      # Returning nil forces the calling code to use the default route instead of ours
      return nil if !defined?(record.nav_items) || record.nav_items.blank?

      # Use the canonical nav item instead.
      record = Trim::NavItem.find_canonical( record.nav_items )
    end

    if record.is_linked? || record.is_route?
      "/#{record.nav_path}"
    else
      record.custom_url
    end
  end
end
