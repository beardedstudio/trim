module Trim
  class TrimMailer < ActionMailer::Base
    append_view_path("#{Rails.root}/app/views/mailers")
    default from: "Bearded <info@bearded.com>"

    # helper :preformat

    def user_defined_mail to, key, params={}
      setting = Setting.factory
      # Use a provided record to populate params from our Setting configuration.
      record = params.delete :record
      unless record.blank?
        config_params = Setting.email_configuration[key].map &:to_s
        params.reverse_merge! record.attributes.slice(*config_params)
      end
      block = liquid_proc setting.send("#{key}_body"), params.stringify_keys
      
      # Don't send mails with no subject or body.
      unless block.blank? || setting.send("#{key}_subject").blank?
        mail :to => to, :subject => setting.send("#{key}_subject"), &block
      end
    end

    def liquid_proc template, params={}
      template = Liquid::Template.parse(template)
      proc { |format|
        format.text { render :text => template.render(params) }
      }
    end
  end
end
