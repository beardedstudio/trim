module Trim
  module RailsAdminDefaultI18n

    def apply_default_i18n
      # We'll be reusing this block for edit & nested.
      default_config = proc do
        fields do
          if [:name, :title].include? self.name
            css_class "#{css_class} large"
          end

          # Let I18n provide help text for forms.
          help do
            model = self.abstract_model.model_name.underscore
            field = self.name
            model_lookup = "admin.help.#{model}.#{field}".to_sym
            field_lookup = "admin.help.#{field}".to_sym
            original = help || ''
            text = I18n.t model_lookup, 
              :help => original, 
              :default => [field_lookup, original]
            # If optional/required is blank, we end up with leading periods...
            text.sub(/^\. ?/, '') unless text.is_a?(Hash)
          end
        end
      end

      edit &default_config
      nested &default_config
    end

  end
end