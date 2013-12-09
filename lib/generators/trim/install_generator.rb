require 'rails/generators/active_record'

module Trim
  # This generator adds a migration for the User model
  class InstallGenerator < TrimGenerator

    def install_trim_models
      generate 'trim:models'
      generate 'trim:navigation'
    end

    def migrate
      say 'Running rake db:migrate', MESSAGE_COLOR

      unless system 'rake db:migrate'
        say "There was an error finalizing the install. 'rake db:migrate' failed", ERROR_COLOR
      end
    end

    def build_default_nav
      Nav.rebuild_navs!
    end

    def install_routes
      generate 'trim:routes'
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

    def add_permissions
      generate 'trim:permissions'

      say "Trim install complete.", SUCCESS_COLOR
    end
  end
end
