require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'
 
module RailsAdmin
  module Config
    module Actions
      class ShowInApp < RailsAdmin::Config::Actions::Base
        
        register_instance_option :controller do
          bindings[:controller].class_eval("include  ::ApplicationHelper")

          proc do
            redirect_to main_app.polymorphic_url(@object)
          end
        end
      end
    end
  end
end