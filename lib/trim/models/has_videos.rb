module Trim
  module HasVideos

    def self.extended(base)
      base.class_eval do
        has_many :videos, :as => :embeddable, :class_name => 'Trim::Video', :dependent => :destroy, :order => 'trim_videos.sort ASC'
        accepts_nested_attributes_for :videos, :allow_destroy => true
        attr_accessible :videos_attributes, :as => :admin
      end
    end

  end
end

