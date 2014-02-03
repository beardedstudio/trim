require 'rails/generators/active_record'

module Trim
  class InstallGenerator < TrimGenerator

    source_root File.expand_path("../../templates", __FILE__)

    def add_initializer_file
      say 'Copying trim initializer file', MESSAGE_COLOR
      template "config/initializers/trim.rb", "config/initializers/trim.rb"
    end

    def install_trim_models
      generate 'trim:models'
      generate 'trim:navigation'
    end

    def install_contact_messages
      if defined?(Trim::ContactMessages)
        generate 'trim:contact_messages'
      end
    end

    def migrate
      say 'Running rake db:migrate', MESSAGE_COLOR

      unless system 'rake db:migrate'
        say "There was an error finalizing the install. 'rake db:migrate' failed", ERROR_COLOR
      end
    end

    def install_admin_gems
      generate 'trim:admin'
    end

    def seed
      migrate
      say 'Running rake db:seed', MESSAGE_COLOR

      unless system 'rake db:seed'
        say "There was an error finalizing the install. 'rake db:seed' failed", ERROR_COLOR
      end
    end

    def copy_application_layout
      say 'Replacing rails default application layout with trim\'s', MESSAGE_COLOR

      remove_file 'app/views/layouts/application.html.erb'
      copy_file   'app/views/layouts/application.html.haml'
    end

    def add_permissions
      generate 'trim:permissions'
      say "Trim install complete.", SUCCESS_COLOR
    end

  end
end
