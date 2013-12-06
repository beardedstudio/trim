module Trim
  module HasImages

    def has_images
      has_many :images, :as => :imageable, :class_name => 'Trim::Image', :dependent => :destroy, :order => 'trim_images.sort ASC'
      accepts_nested_attributes_for :images, :allow_destroy => true
      attr_accessible :images_attributes
    end

  end
end

ActiveRecord::Base.extend Trim::HasImages
