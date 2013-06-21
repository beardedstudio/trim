class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :initialize_editables

  before_filter :reload_rails_admin, :if => :rails_admin_path?

  rescue_from CanCan::AccessDenied do |exception|
    type = flash[:notice].blank? ? :alert : :notice

    path = if user_signed_in?
      flash[:alert] = "You are not authorized to do that."
      main_app.root_path
    else
      flash[:alert] = "Please log in or sign up for an account first."
      main_app.new_user_session_path
    end

    redirect_to path
  end

  def reload_rails_admin
    models = RailsAdmin::Config.registry.keys
    models.each do |m|
      RailsAdmin::Config.reset_model(m)
    end
    RailsAdmin::Config::Actions.reset

    load("#{Rails.root}/config/initializers/rails_admin.rb")
    models.each do |m|
      m.rails_admin if m.respond_to?(:rails_admin)
    end
  end

  def rails_admin_path?
    controller_path =~ /rails_admin/ && Rails.env == "development"
  end

  def initialize_editables
    @editables ||= []
  end

  def add_to_editables
    @editables << resource
  end

  def after_sign_in_path_for(resource)
    redirect_back_path || super
  end

  def current_ability
    @current_ability ||= Ability.new(current_user, request.session_options[:id])
  end

  def initialize_variables
    # since rails_admin inherits from ApplictionController,
    # we either need to check for this or move our filters 
    # to an intermediate controller
    unless self.respond_to?(:rails_admin_controller?) && rails_admin_controller?
      @navs = {}

      Trim::Nav.default_navs.each do |nav|
        nav.tree if nav.use_as_root
        @navs[nav.slug.to_sym] = nav
      end

      # @setting ||= Setting.factory

      # @editables ||= []

      path = request.env['ORIGINAL_PATH_INFO']
      self.initialize_breadcrumbs path
    end
  end

  def initialize_breadcrumbs(path)
    @breadcrumbs = !@navs[:global].nil? && @navs[:global].breadcrumbs(path) ? @navs[:global].breadcrumbs(path) : []
    @section = @breadcrumbs[1] unless @breadcrumbs.size < 1
  end

  def set_active_menu_item_by_route_name(path, route_name)
    # This sets a specific item as the active item for the nav for this controller.
    # It's not an ideal design, but it proved difficult to do something more automatic.
    set_active_menu_item path, Trim::NavItem.find_by_route(route_name)
  end

  def set_active_menu_item_by_slug(path, slug)
    set_active_menu_item path, Trim::NavItem.find_by_slug(slug)
  end

  def set_active_menu_item(path, item)
    @navs[:global].set_active_item item, path unless item.blank?
  end

  # Redirect to the "real" content URL when available.
  #
  # Usage: return if conditional_redirect_to_navigation_path(item)
  #
  # We don't want to do this a lot, because unnecessary redirects slow things
  # down for everyone, but this is a backstop so people don't end up at the
  # wrong URL.
  def conditional_redirect_to_navigation_path(item)
    path = polymorphic_path(item)
    # We have to compare against the unaltered PATH_INFO.
    original_path = request.env['ORIGINAL_PATH_INFO']
    if path != original_path && original_path != root_path
      redirect_to(path)
      return true
    end
    false
  end

end
