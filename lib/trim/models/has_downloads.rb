module Trim
  module HasDownloads
    
    def has_downloads
      has_many :downloads, :as => :downloadable, :dependent => :destroy, :order => :sort, :class_name => 'Trim::Download'
      accepts_nested_attributes_for :downloads, :allow_destroy => true
    end

  end
end

ActiveRecord::Base.extend Trim::HasDownloads
