module Trim
  module HasNavItems
    
    def has_nav_items
      has_many :nav_items, :as => :linked, :inverse_of => :linked, :dependent => :destroy, :class_name => 'Trim::NavItem'
      after_save :update_nav_items
      accepts_nested_attributes_for :nav_items, :allow_destroy => true
      attr_accessible :nav_items_attributes

      # has_many :redirects, :as => :destination, :dependent => :destroy
      # accepts_nested_attributes_for :redirects, :allow_destroy => true
      # attr_accessible :redirects_attributes

      send :include, InstanceMethods
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

ActiveRecord::Base.extend Trim::HasNavItems