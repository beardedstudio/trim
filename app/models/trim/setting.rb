module Trim
  class Setting < ActiveRecord::Base

    def self.setting_fields
      [ :twitter_name,
        :facebook_url,
        :street_address,
        :city,
        :state,
        :zip_code,
        :phone_number,
        :contact_email,
        :meta_description,
        :meta_keywords] + Trim.additional_settings + self.email_attributes
    end

    def self.notify_attributes
    end

    def self.email_configuration
      Trim.setting_email_keys
    end

    def self.email_attributes
      keys = self.email_configuration.keys
      keys.map { |k| ["#{k}_subject".to_sym, "#{k}_body".to_sym] }.flatten! || []
    end

    def self.email_placeholder_string(key)
      email_configuration[key].map{ |placeholder| "{{ #{placeholder} }}" }.join(' ')
    end

    store :settings, :accessors => Setting.setting_fields

    attr_accessible *setting_fields

    def self.factory
      Setting.first || Setting.create
    end

    rails_admin do
      visible false
    end
  end
end