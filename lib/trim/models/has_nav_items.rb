module Trim
  module HasNavItems

    def self.extended(base)
      base.class_eval do
        has_many :nav_items, :as => :linked, :class_name => 'Trim::NavItem', :inverse_of => :linked, :dependent => :destroy

        after_save Proc.new{ self.nav_items.each &:save }

        accepts_nested_attributes_for :nav_items, :allow_destroy => true
        attr_accessible :nav_items_attributes, :as => Trim.attr_accessible_role
      end
    end

  end
end
