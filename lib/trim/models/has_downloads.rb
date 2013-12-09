module Trim
  module HasDownloads

    def self.extended(base)
      base.class_eval do
        has_many :downloads, :as => :downloadable, :class_name => 'Trim::Download', :dependent => :destroy, :order => 'trim_downloads.sort ASC'
        accepts_nested_attributes_for :downloads, :allow_destroy => true
        attr_accessible :downloads_attributes
      end
    end
    
  end
end
