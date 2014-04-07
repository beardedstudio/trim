module Trim
  class Download < ActiveRecord::Base
    attr_accessible :title, :sort, :download, :downloadable, :as => :admin

    belongs_to :downloadable, :polymorphic => true

    has_attached_file :download,
      :storage => :s3,
      :s3_credentials => {
        :bucket => ENV['AWS_BUCKET'],
        :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
        :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']},
      :s3_headers => { 'Cache-Control' => 'max-age=315576000', 'Expires' => 1.years.from_now.httpdate },
      :path => '/downloads/:id/:filename'

    def link_text
      title.blank? ? download_file_name : title
    end

    #
    # Rails Admin Config
    #
    rails_admin do
      visible false
      nested do
        field :download
        field :title
        field :sort
      end
    end

  end
end
