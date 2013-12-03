module Trim
  module HasLeadItems
    
    def has_lead_items
      has_one :lead_image, :as => :imageable, :class_name => 'Trim::LeadImage', :dependent => :destroy
      accepts_nested_attributes_for :lead_image, :allow_destroy => true, :reject_if => proc { |item| item[:image].blank? }
    end

  end
end

ActiveRecord::Base.extend Trim::HasLeadItems
