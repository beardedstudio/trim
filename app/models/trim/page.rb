module Trim
  class Page < ActiveRecord::Base

    # Enable friendly_id
    extend FriendlyId
    friendly_id :title_or_custom, :use => [:slugged]

    # Enable pages to be in nav
    extend HasNavItems

    # Enable Media and Relationships
    extend HasLeadItems
    extend HasImages
    extend HasDownloads
    extend HasRelatedItems
    extend HasVideos

    # Allow excerpting of body/teaser
    extend HasExcerpt
    has_excerpt :field => :body, :length => 150

    attr_accessible :title, :body, :intro, :excerpt, :teaser, :slug, :custom_slug, :is_private

    validates :title, :presence => true
    validates :teaser, :length => { :maximum => 150, :message => "Your teaser is too long (the maximum is 150 characters)." }, :allow_blank => true

    # Generate friendly_id from custom_slug, or title if absent.
    def title_or_custom
      self.custom_slug.blank? ? self.title : self.custom_slug
    end

    #
    # RailsAdmin Config
    #
    rails_admin do
      navigation_label 'Content'
      weight -9

      configure :body do
        pretty_value do
          value.html_safe unless value.nil?
        end
      end

      configure :excerpt do
        read_only true

        pretty_value do
          value.html_safe unless value.nil?
        end
      end

      configure :slug do
        read_only true
      end

      list do
        fields :title, :created_at
      end

      edit do
        field :title
        field :lead_image
        field :body do
          ckeditor true
        end

        group :excerpt do
          label "Related / List View"
          active false

          field :excerpt
          field :teaser
        end

        group :media do
          label "Media and Related Items"
          active false

          field :images
          field :downloads
          field :videos
          field :related_items
        end

        group :admin do
          label "Administration"
          active false

          field :nav_items
          field :slug
          field :custom_slug
        end
      end

      extend RailsAdminDefaultI18n
      apply_default_i18n
    end
  end
end