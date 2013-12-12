module Trim

  class RoutesGenerator < TrimGenerator

    def add_navigation_filter_to_routes
      route("filter :navigation")
      say "Added navigation filter to config/routes.rb", MESSAGE_COLOR
    end

    def add_route_for_home
      route("root to: 'home#index'")
      say "Added root route to config/routes.rb", MESSAGE_COLOR
    end

    def add_route_for_pages
      route("resources :pages, :only => :show")
      say "Added pages routes to config/routes.rb", MESSAGE_COLOR
    end

    def add_route_for_nav_items
      route("resources :nav_items, :only => :show")
      say "Added navigation items routes to config/routes.rb", MESSAGE_COLOR
    end
  end
end