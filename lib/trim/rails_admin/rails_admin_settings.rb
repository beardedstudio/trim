require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'
 
module RailsAdmin
  module Config
    module Actions
      class Settings < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :link_icon do
          'icon-cog'
        end

        register_instance_option :http_methods do
          [:get, :put]
        end

        register_instance_option :root? do
          true
        end

        register_instance_option :controller do
          proc do
            @setting = Setting.factory
            if request.get?

            else
              @setting.update_attributes params[:setting]
              if @setting.save
                flash[:success] = "Settings have been saved."
              else
                flash[:error] = "Settings have not been saved."
              end
              redirect_to settings_path
            end
          end
        end

      end
    end
  end
end