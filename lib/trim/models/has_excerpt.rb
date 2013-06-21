module Trim
  module HasExcerpt

    class TextHelper
      include ::ActionView::Helpers::TextHelper
    end


    def has_excerpt options={}
      options.reverse_merge!({
        :field => :body,
        :length => 150,
      })

      class << self
        attr_accessor :excerpt_options
      end

      self.excerpt_options = options
      before_save :create_excerpt

      send :include, InstanceMethods 
    end

    module InstanceMethods
      def create_excerpt

        helper = HasExcerpt::TextHelper.new

        # Teaser overrides truncated body.
        # It is presumed that teaser is character limited to the exerpt length.
        if self.respond_to?(:teaser) && !self.teaser.blank?
          excerpt = self.teaser
        else
          # Render Liquid if appropriate.
          excerpt = if self.respond_to? :liquid_render
            self.liquid_render :field => self.class.excerpt_options[:field]
          else
            self.send self.class.excerpt_options[:field]
          end
          
          excerpt = helper.strip_tags(excerpt)
          excerpt = helper.truncate excerpt, :length => self.class.excerpt_options[:length], :separator => ' ', :omission => '&#8230;'
        end      

        self.excerpt = excerpt.strip.html_safe
      end
    end

  end
end

ActiveRecord::Base.extend Trim::HasExcerpt