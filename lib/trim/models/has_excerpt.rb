module Trim
  module HasExcerpt

    class TextHelper
      include ::ActionView::Helpers::TextHelper
    end

    def self.extended(base)
      base.class_eval do
        send :include, InstanceMethods
      end

      def has_excerpt(options = {})
        options.reverse_merge!({ :field => :body, :length => 150 })

        class << self
          attr_accessor :excerpt_options
        end

        self.excerpt_options = options
        before_save :create_excerpt
      end
    end

    module InstanceMethods
      def create_excerpt

        helper = HasExcerpt::TextHelper.new

        # Teaser overrides truncated body.
        # It is presumed that teaser is character limited to the exerpt length.
        excerpt = if self.respond_to?(:teaser) && !self.teaser.blank?
          self.teaser
        else
          full = self.send self.class.excerpt_options[:field]

          full = helper.strip_tags(full)

          helper.truncate full, :length => self.class.excerpt_options[:length], :separator => ' ', :omission => '&#8230;'
        end

        self.excerpt = excerpt.strip.html_safe
      end
    end

  end
end
