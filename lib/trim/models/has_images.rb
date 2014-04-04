module Trim
  module HasImages

    def self.extended(base)
      base.class_eval do
        has_many :images, :as => :imageable, :class_name => 'Trim::Image', :dependent => :destroy, :order => 'trim_images.sort ASC'
        accepts_nested_attributes_for :images, :allow_destroy => true
        attr_accessible :images_attributes, :as => Trim.attr_accessible_role
      end
    end

  end
end

