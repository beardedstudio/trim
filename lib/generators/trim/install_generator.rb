require 'rails/generators'
require 'rails/generators/active_record'

module Trim
  # This generator adds a migration for the User model
  class InstallGenerator < Rails::Generators::Base

    MESSAGE_COLOR = :yellow
    ERROR_COLOR = :red
    SUCCESS_COLOR = :green

    include Rails::Generators::Migration

    source_root File.expand_path('../../templates', __FILE__)

    def self.next_migration_number(path)
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    end

    def install_rails_admin
      generate "rails_admin:install user admin"
    end

    def add_user_columns_migration(*args)
      # ensure migration timestamps are different
      sleep(2)

      generate 'migration AddNameToUsers name:string'

      gsub_file 'app/models/user.rb', /:registerable\,/, ''
    end

    def add_admin_user_to_seeds(*args)
      code = <<-code
User.create!  :email => 'admin@example.com',
              :name => 'Administrator',
              :password => 'password',
              :password_confirmation => 'password'
      code

      append_to_file 'db/seeds.rb', code
    end

    def ensure_filtering_devise_password_parameters(*args)
      say 'Securing filtered parameters for devise', MESSAGE_COLOR
      application 'config.filter_parameters << :password_confirmation'
    end

    def install_cancan(*args)
      say 'Installing Cancan', MESSAGE_COLOR
      generate 'cancan:ability'

      code = <<-code
        user ||= User.new
        can :manage, :all if user.persisted?
      code

      insert_into_file 'app/models/ability.rb', code, :after => 'def initialize(user)'
    end

    def add_rails_admin_user_config
      rails_admin_config = <<-config
  rails_admin do
    navigation_label 'Users'

    include_fields :name, :email, :created_at

    show do
      fields :updated_at, :sign_in_count, :current_sign_in_ip, :last_sign_in_ip
    end

    edit do
      fields :password, :password_confirmation
    end
  end
      config

      insert_into_file 'app/models/user.rb', rails_admin_config, :before => "end"
      say "Added rails_admin user config"
    end

    def execute_rake_tasks
      tasks = { :migrate => 'rake db:migrate',
                :seed => 'rake db:seed' }

      tasks.each do |name, task|

        say "Running #{task}", MESSAGE_COLOR
        if system tasks[name]
          tasks.delete name
        else
          say "There was an error finalizing the install. Task Failed: '#{task}'", ERROR_COLOR
        end
      end

      say "Trim install complete.", SUCCESS_COLOR if tasks.empty?
    end
  end
end