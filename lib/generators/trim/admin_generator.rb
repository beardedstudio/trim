require 'rails/generators/active_record'

module Trim
  # This generator adds a migration for the User model
  class AdminGenerator < TrimGenerator

    include Rails::Generators::Migration

    source_root File.expand_path('../../templates', __FILE__)

    def self.next_migration_number(path)
      Time.now.utc.strftime("%Y%m%d%H%M%S")
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

Nav.rebuild_navs!
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

    def strip_rails_admin_config_comments
      gsub_file 'config/initializers/rails_admin.rb', /^\s*#.*\n/, ''
    end

    def add_rails_admin_action_config
      rails_admin_config = <<-config
  config.authorize_with :cancan, Ability
  #config.audit_with :paper_trail, User
  config.compact_show_view = false

  # Exclude specific models (keep the others):
  config.excluded_models = [Ability, Trim::Nav]

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
        bindings[:abstract_model].model.to_s == 'Trim::NavItem'
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

    def add_root_route
      route 'root to: \'home#index\''
    end
  end
end