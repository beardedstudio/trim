require 'rails_admin/config'
require 'rails_admin/config/fields/base'

module RailsAdmin
  module Config
    module Fields
      module Types
        class HasManyAssociation < RailsAdmin::Config::Fields::Association

          register_instance_option :orderable do
            @orderable ||= :sort
          end 

          RailsAdmin::Config::Fields::Types.register(self)
        end
      end
    end
  end
end
