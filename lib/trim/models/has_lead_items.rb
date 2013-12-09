module Trim
  module HasLeadItems

    def self.extended(base)
      base.class_eval do
        has_one :lead_image, :as => :imageable, :class_name => 'Trim::LeadImage', :dependent => :destroy
        accepts_nested_attributes_for :lead_image, :allow_destroy => true, :reject_if => proc { |item| item[:image].blank? }
        attr_accessible :lead_image_attributes
      end
    end

  end
end
