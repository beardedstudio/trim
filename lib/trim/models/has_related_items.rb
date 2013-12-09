module Trim
  module HasRelatedItems

    def self.extended(base)
      base.class_eval do
        has_many :related_items, :as => :related_from, :class_name => 'Trim::RelatedItem', :inverse_of => :related_from, :dependent => :destroy, :order => 'trim_related_items.sort ASC'
        has_many :relating_items, :class_name => 'Trim::RelatedItem', :as => :related_to, :inverse_of => :related_to

        accepts_nested_attributes_for :related_items, :allow_destroy => true
        attr_accessible :related_items_attributes
      end
    end

  end
end

