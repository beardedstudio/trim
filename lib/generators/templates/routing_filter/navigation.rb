class Navigation < RoutingFilter::Filter
  include ActionDispatch::Routing::UrlFor
  include ActionDispatch::Routing::Redirection
  include Rails.application.routes.url_helpers

  def around_recognize(path, env, &block)
    # We're not going to do this twice for the same request also
    # do not look for nav items if this is a request for an asset.
    yield if defined? env['ORIGINAL_PATH_INFO']

    yield if path =~ /^\/assets/ and return

    # We need a copy of the original path because the alteration is done in place.
    env['ORIGINAL_PATH_INFO'] = path.clone

    # Get the path without the leading slash.
    local_path = path.sub(/^\//, '')

    unless local_path.blank?
      item = found = Trim::NavItem.find_by_path(local_path)
      unless item.blank? || item.linked.blank? || !item.route.blank?
        set_rails_path_for_record item.linked, path
      end

      # redirect = found = Redirect.find_by_path(local_path)
      # unless redirect.nil? || !found
      #   set_rails_path_for_record redirect, path
      # end
    end

    yield.tap do |params|
      # You can additionally modify the params here before they get passed
      # to the controller.
    end
  end

  def around_generate(params, &block)
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

  def set_rails_path_for_record(record, path)
    # Passing the :navigation_filter parameter disables our custom generate below.
    # We have to modify the string in place, or it doesn't affect subsequent wrappers.
    path.replace polymorphic_path(record, :navigation_filter => false)
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

    unless record.is_a?(Trim::NavItem)
      # This forces the calling code to use the default route instead of ours
      return nil if !defined?(record.nav_items) || record.nav_items.blank?

      # Use the nav item instead.
      record = record.nav_items.first
    end

    # NavItems with routes should use their options with url_for.
    record.route.blank? ? "/#{record.path}" : record.url_options
  end
end
