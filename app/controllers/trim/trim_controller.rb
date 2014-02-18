module Trim
  class TrimController < ApplicationController
    layout 'application'

    protect_from_forgery

    before_filter :redirect_to_canonical, :prepend => true
    before_filter :initialize_editables
    before_filter :initialize_variables

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

    def initialize_editables
      @editables ||= []
    end

    def add_to_editables
      @editables << resource
    end

    def current_ability
      @current_ability ||= Ability.new(current_user)
    end

    def initialize_variables
      # since rails_admin inherits from ApplictionController,
      # we either need to check for this or move our filters
      # to an intermediate controller
      unless self.respond_to?(:rails_admin_controller?) && rails_admin_controller?
        @navs = {}
        Trim::Nav.all.each do |nav|
          @navs[nav.slug.to_sym] = nav
        end

        set_active_nav_item
        
        @setting ||= Trim::Setting.factory

        @editables ||= []
      end
    end

    def set_active_nav_item( nav_item = nil )
      @active_nav_item = nav_item.nil? ? Trim::NavItem.find_active_by(request.env['ORIGINAL_PATH_INFO']) : nav_item
      if @active_nav_item.nil?
        @active_nav = Trim::Nav.get_default
        @active_nav_item = @active_nav.nav_item
      else
        @active_nav = @active_nav_item.nav
      end

      @breadcrumbs = @active_nav_item.path
    end

    # Redirect to the "real" content URL when available.
    #
    # Usage: return if conditional_redirect_to_navigation_path(item)
    #
    # We don't want to do this a lot, because unnecessary redirects slow things
    # down for everyone, but this is a backstop so people don't end up at the
    # wrong URL.
    def conditional_redirect_to_navigation_path(item)
      item_path = polymorphic_path(item)
      # We have to compare against the unaltered PATH_INFO.
      original_path = request.env['ORIGINAL_PATH_INFO']
      if item_path != original_path && original_path != root_path
        redirect_to(item_path)
        return true
      end
      false
    end

    def redirect_to_canonical
      path = env['ORIGINAL_PATH_INFO'].sub(/^\//, '')
      nav_item = Trim::NavItem.find_active_by( path )
      if nav_item
        canonical = nav_item.find_canonical_by_nav_item
        if nav_item.id != canonical.id || path != canonical.nav_path
          redirect_to "/#{canonical.nav_path}"
        end
      end
    end

  end
end

