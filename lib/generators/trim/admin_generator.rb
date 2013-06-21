require 'rails/generators'
require 'rails/generators/active_record'
    
module Trim
  # This generator adds a migration for the User model
  class AdminGenerator < Rails::Generators::Base
    include Rails::Generators::Migration
    source_root File.expand_path('../../templates', __FILE__)
    
    def self.next_migration_number(path)
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    end

    def install_rails_admin
      if ENV['SKIP_RAILS_ADMIN_INITIALIZER'].nil?
        ENV['SKIP_RAILS_ADMIN_INITIALIZER'] = 'true'
        puts "[RailsAdmin] RailsAdmin initialization disabled by default. Pass SKIP_RAILS_ADMIN_INITIALIZER=false if you need it."
      end

      generate "rails_admin:install user admin"
    end

    def install_paper_trail
      generate 'paper_trail:install'
    end

    def add_user_columns_migration(*args)
      # ensure migration timestamps are different
      sleep(2)

      generate 'migration AddNameToUsers name:string'

      gsub_file 'app/models/user.rb', /:registerable\,/, ''

      insert_into_file 'app/models/user.rb', ':name, ', :after => "attr_accessible "
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
      puts 'Securing filtered parameters for devise'
      application 'config.filter_parameters << :password_confirmation'
    end

    def add_rails_admin_user_config
      rails_admin_config = <<-config
  rails_admin do
    navigation_label 'Users'

    include_fields :name, :email, :sign_in_count, :created_at
    
    show do 
      fields :updated_at, :current_sign_in_ip, :last_sign_in_ip
    end
  end
      config
      insert_into_file 'app/models/user.rb', rails_admin_config, :before => 'end'
    end

    def strip_rails_admin_config_comments
      gsub_file 'config/initializers/rails_admin.rb', /^\s*#.*\n/, ''
    end

    def add_rails_admin_action_config
      rails_admin_config = <<-config
  config.authorize_with :cancan, Ability
  config.audit_with :paper_trail, User
  config.compact_show_view = false
  
  # Exclude specific models (keep the others):
  config.excluded_models = [Ability, Trim::Nav, Version]

  # Configure Actions
  config.actions do

    # root actions
    dashboard
    settings

    # collection actions 
    index
    new
    export
    history_index
    bulk_delete
    nested_sort do
      visible do
        ['Trim::NavItem'].include? bindings[:abstract_model].model.to_s
      end
    end

    # member actions
    show
    edit
    delete
    history_show
    show_in_app
    
  end
      config

      insert_into_file 'config/initializers/rails_admin.rb', rails_admin_config, :before => 'end'
    end

  end
end