module Trim
  module HasImages
    
    def has_images
      has_many :images, -> { order('trim_images.sort ASC') }, :as => :imageable, :class_name => 'Trim::Image', :dependent => :destroy
      accepts_nested_attributes_for :images, :allow_destroy => true
    end

  end
end

ActiveRecord::Base.extend Trim::HasImages
