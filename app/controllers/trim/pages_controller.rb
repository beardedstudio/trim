module Trim
  class PagesController < InheritedController
    defaults :resource_class => Trim::Page

    load_and_authorize_resource :page

    before_filter :handle_page

    def handle_page
      return if conditional_redirect_to_navigation_path @page
      session.delete(:tried_private_page) if session[:tried_private_page]
    end

    def permitted_params
      params.permit(:page => [:id, :body])
    end
  end
end
