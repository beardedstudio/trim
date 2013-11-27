require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'

module RailsAdmin
  module Config
    module Actions
      class Reorder < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        # There are several options that you can set here. 
        # Check https://github.com/sferik/rails_admin/blob/master/lib/rails_admin/config/actions/base.rb for more info.
 
        register_instance_option :link_icon do
          'icon-move'
        end

        register_instance_option :http_methods do
          [:get, :post]
        end

        register_instance_option :collection? do
          true
        end

        register_instance_option :controller do
          proc do
            # we need the items from the model
            class_reference = self.abstract_model.model_name.constantize
            @items = class_reference.all

            # we only accept get and post
            if request.get?

            else
              ret = []
              type = 'success'
              class_reference.transaction do 
                params[:item].each do |param|
                  item = self.abstract_model.model_name.constantize.find(param[0])
                  item.sort = param[1]
                  if item.save == false
                    type = 'error'
                    ret << { item.id => item.errors }
                    raise ActiveRecord::Rollback
                  else
                    ret << { item.id => { "name" => item.title, "sort" => item.sort } }
                  end
                end
              end
              if (params[:ajax] == 'true')
                render :json => { type => ret }
              else
                if type == 'success'
                  flash[:success] = 'Saved successfully!'
                elsif type == 'error'
                  flash[:error] = 'There was a problem saving the order of the items'
                end
                redirect_to reorder_path(:model_name => self.abstract_model.to_param)
              end
            end

          end
        end
      end
    end
  end
end