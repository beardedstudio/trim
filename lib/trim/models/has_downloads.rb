module Trim
  module HasDownloads
    
    def has_downloads
      has_many :downloads, -> { order('trim_downloads.sort ASC') }, :as => :downloadable, :class_name => 'Trim::Download', :dependent => :destroy
      accepts_nested_attributes_for :downloads, :allow_destroy => true
    end

  end
end

ActiveRecord::Base.extend Trim::HasDownloads
