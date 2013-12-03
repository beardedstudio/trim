module Trim
  module HasRelatedItems
    
    def has_related_items
      has_many :related_items, -> { order('trim_related_items.sort ASC') }, :as => :related_from, :class_name => 'Trim::RelatedItem', :inverse_of => :related_from, :dependent => :destroy
      has_many :relating_items, :class_name => 'Trim::RelatedItem', :as => :related_to, :inverse_of => :related_to
      
      accepts_nested_attributes_for :related_items, :allow_destroy => true
    end

  end
end

ActiveRecord::Base.extend Trim::HasRelatedItems
