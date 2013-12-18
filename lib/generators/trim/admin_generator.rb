require 'rails/generators/active_record'

module Trim
  # This generator adds a migration for the User model
  class AdminGenerator < TrimGenerator

    include Rails::Generators::Migration

    source_root File.expand_path('../../templates', __FILE__)

    def self.next_migration_number(path)
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    end

    def copy_rails_admin_config
      say "copying Rails Admin config"
      template "config/initializers/rails_admin.rb", "config/initializers/rails_admin.rb"
    end

    def install_rails_admin
      if ENV['SKIP_RAILS_ADMIN_INITIALIZER'].nil?
        ENV['SKIP_RAILS_ADMIN_INITIALIZER'] = 'true'
        say "[RailsAdmin] RailsAdmin initialization disabled by default. Pass SKIP_RAILS_ADMIN_INITIALIZER=false if you need it."
      end

      generate "rails_admin:install user admin"
    end

    # def install_paper_trail
    #   generate 'paper_trail:install'
    # end

    def add_user_columns_migration
      # ensure migration timestamps are different
      sleep(2)

      generate 'migration AddNameToUsers name:string'

      gsub_file 'app/models/user.rb', /:registerable\,/, ''
    end

    def add_user_attr_accessible
      say 'adding name to user\'s attr_accessible list'
      insert_into_file 'app/models/user.rb', ':name, ', :after => 'attr_accessible '
    end

    def add_seeds
      code = <<-code
user = User.find_by_email 'admin@example.com'

User.create!( :email => 'admin@example.com',
              :name => 'Administrator',
              :password => 'password',
              :password_confirmation => 'password') if user.nil?

Trim::Nav.rebuild_navs!
      code

      # make a seeds file if it doesn't exist.
      # test installs of rails don't include this.
      create_file 'db/seeds.rb' unless File.exists? 'db/seeds.rb'
      append_to_file 'db/seeds.rb', code
    end

    def ensure_filtering_devise_password_parameters
      say 'Securing filtered parameters for devise', MESSAGE_COLOR
      application 'config.filter_parameters << :password_confirmation'
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
      insert_into_file 'app/models/user.rb', rails_admin_config, :before => 'end'

      say "Added rails_admin user config", MESSAGE_COLOR
    end

    def add_root_route
      route 'root to: \'home#index\''
    end
  end
end