module Trim
  module HasImages
    
    def has_images
      has_many :images, :as => :imageable, :dependent => :destroy, :order => :sort, :class_name => 'Trim::Image'
      accepts_nested_attributes_for :images, :allow_destroy => true
    end

  end
end

ActiveRecord::Base.extend Trim::HasImages
