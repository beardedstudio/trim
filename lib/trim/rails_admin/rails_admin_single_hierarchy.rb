require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'
 
module RailsAdmin
  module Config
    module Actions
      class SingleHierarchy < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)
 
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
            if request.get?

            else
              changes = {}

              i = 0

              params[:service].each do |svc_id, parent_id|
                # get the original item.
                s = Service.find(svc_id)

                # store the original
                orig_parent = s.parent_id
                orig_sort = s.sort

                # nils and nulls.
                p = parent_id unless parent_id == 'null'
                p = nil if parent_id == 'null'

                # only update if we need to
                if i != orig_sort || parent_id != orig_parent
                  s.update_attributes(
                    :sort => i,
                    :parent_id => p
                  )
                  changes[s.id] = { :parent_id => s.parent_id, :sort => s.sort }
                end

                i += 1
              end

              render :json => changes
            end
          end
        end
      end
    end
  end
end