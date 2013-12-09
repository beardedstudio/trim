module Trim
  module HasNavItems

    def self.extended(base)
      base.class_eval do
        has_many :nav_items, :as => :linked, :class_name => 'Trim::NavItem', :inverse_of => :linked, :dependent => :destroy
        after_save :update_nav_items
        accepts_nested_attributes_for :nav_items, :allow_destroy => true

        attr_accessible :nav_items_attributes
        
        send :include, InstanceMethods
      end
    end

    module InstanceMethods
      def update_nav_items
        self.nav_items.each do |item|
          item.save
        end
      end
    end

  end
end
