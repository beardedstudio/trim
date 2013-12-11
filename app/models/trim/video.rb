require 'oembed'

module Trim
  class Video < ActiveRecord::Base

    YOUTUBE = 'YouTube'
    VIMEO = 'Vimeo'

    PROVIDERS = { YOUTUBE => 1,
                  VIMEO => 2 }

    attr_accessible :video_url, :caption, :sort, :embeddable, :provider

    belongs_to :embeddable, :polymorphic => true

    validates :sort, :numericality => { :only_integer => true }, :presence => true
    validates :video_url, :presence => true
    validates :provider, :presence => true, :inclusion => { :in => PROVIDERS.values }
    validate :url_must_be_valid

    def title
      self.caption.truncate 15
    end

    def oembed
      begin

        oembed_for_provider.get(video_url, get_options_for_provider)

      rescue OEmbed::UnknownResponse => exception
      end
    end

    def oembed_for_provider
      youtube? ? OEmbed::Providers::Youtube : OEmbed::Providers::Vimeo
    end

    def url_must_be_valid
      begin
        oembed_for_provider.get video_url

      rescue OEmbed::UnknownResponse => exception
        errors.add(:video_url, "could not be found. Please ensure it exists, the url is correct, and the video is publicly available.")

      rescue OEmbed::NotFound => exception
        errors.add(:video_url, "must be a valid #{PROVIDERS.key(provider)} URL")
      end
    end

    def youtube?
      provider == PROVIDERS[YOUTUBE]
    end

    def vimeo?
      provider == PROVIDERS[VIMEO]
    end

    def provider_enum
      PROVIDERS.to_a
    end

    def get_options_for_provider
      if youtube?
        { :rel => 0, :autohide => 1, :showinfo => 0, :theme => 'light'}
      elsif vimeo?
        { :title => false, :byline => false, :portrait => false }
      end
    end

    rails_admin do
      label 'Video'
      visible false
      nested do
        include_fields :video_url, :caption
        field :provider, :enum
        field :sort
      end
    end
  end
end
