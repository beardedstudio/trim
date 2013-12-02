module Trim
  class Image < ActiveRecord::Base

    belongs_to :imageable, :polymorphic => true

    has_attached_file :image,
      :storage => :s3,
      :s3_credentials => {
        :bucket => ENV['AWS_BUCKET'],
        :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
        :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']},
      :s3_headers => { 'Cache-Control' => 'max-age=315576000', 'Expires' => 1.years.from_now.httpdate },
      :path => '/images/:id/:style/:filename',
      :styles => { 
        :thumb => "300x200>", 
      },
      :convert_options => {
        :thumb => '-strip -interlace Plane -quality 85',
      }

    validates_attachment_presence :image
    validates_numericality_of :sort

    scope :random, order("RANDOM()")

    before_save Proc.new{ self.imageable.touch }

    def title
      self.caption.truncate 15
    end

    def to_liquid
      self.image.url
    end

    def style_for_inline
      vertical ? :vertical : :inline
    end
    
    rails_admin do
      visible false

      nested do    
        field :image do
          thumb_method :thumb
        end  
        fields :image, :caption, :alt_text, :vertical, :sort
      end
    end

  end
end
