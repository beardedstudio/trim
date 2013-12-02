module Trim
  class LeadImage < ActiveRecord::Base

    belongs_to :imageable, :polymorphic => true

    has_attached_file :image,
      :storage => :s3,
      :s3_credentials => { :access_key_id => ENV['S3_ACCESS_KEY_ID'],
                           :secret_access_key => ENV['S3_SECRET_ACCESS_KEY'],
                           :bucket => ENV['S3_BUCKET']},

      :s3_headers => { 'Cache-Control' => 'max-age=315576000', 'Expires' => 1.years.from_now.httpdate },
      :path => '/lead_images/:id/:style/:filename',
      :styles => {
        :thumb => "300x200>",
      },
      :convert_options => {
        :thumb => '-strip -interlace Plane -quality 85',
      }

    validates_attachment_presence :image

    before_save Proc.new{ self.imageable.touch }

    def title
      self.id.blank? ? "New Lead Image" : "Lead Image ##{self.id}"
    end

    def to_liquid
      self.image.url
    end

    rails_admin do
      visible false

      nested do
        field :image do
          thumb_method :thumb
        end
        field :alt_text
      end
    end

  end
end