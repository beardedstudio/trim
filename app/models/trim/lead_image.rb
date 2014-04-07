module Trim
  class LeadImage < ActiveRecord::Base

    belongs_to :imageable, :polymorphic => true

    has_attached_file :image,
      :storage => :s3,
      :s3_credentials => {
        :bucket => ENV['AWS_BUCKET'],
        :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
        :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']},

      :s3_headers => { 'Cache-Control' => 'max-age=315576000', 'Expires' => 1.years.from_now.httpdate },
      :path => '/lead_images/:id/:style/:filename',
      :styles => Trim.image_styles,
      :convert_options => Trim.image_convert_options

    attr_accessible :alt_text, :caption, :image, :imageable, :as => :admin

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