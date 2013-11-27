require 'liquid'

module Trim
  module RendersLiquid

    def renders_liquid
      send :include, InstanceMethods 
    end

    module InstanceMethods
      def liquid_render options={}
        options.reverse_merge!({
          :field => :body,
          :params => {},
        })
        template = Liquid::Template.parse(self.send options[:field])
        template.render(self.to_liquid options[:params]).html_safe
      end

      def to_liquid params={}
        params.reverse_merge! self.attributes.except('id', 'body', 'created_at', 'updated_at')
      end

      def includes_contact_form_markup?
        !(self.body =~ /\{\s*contact_form\s*\}\}/).nil?
      end
    end

  end
end
  
ActiveRecord::Base.extend Trim::RendersLiquid