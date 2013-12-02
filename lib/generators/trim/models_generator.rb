require 'rails/generators'
require 'rails/generators/active_record'

module Trim
  # This generator adds a migration for the User model
  class ModelsGenerator < Rails::Generators::Base

    MESSAGE_COLOR = :yellow
    ERROR_COLOR = :red
    SUCCESS_COLOR = :green

    include Rails::Generators::Migration
    source_root File.expand_path('../../templates', __FILE__)

    def self.next_migration_number(path)
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    end

    def install_cancan(*args)
      say 'Installing Cancan', MESSAGE_COLOR
      generate 'cancan:ability'

      code = <<-code

    user ||= User.new
    can :manage, :all if user.persisted?
      code

      insert_into_file 'app/models/ability.rb', code, :after => 'def initialize(user)'

      say "Added Cancan rule for persisted users.", MESSAGE_COLOR
    end

    def create_friendly_id_history_table
      sleep(2)
      puts 'Installing Friendly Id'
      generate 'friendly_id'

      say "Installed friendly_id", MESSAGE_COLOR
    end

    def create_navs
      sleep(2)
      puts 'Installing Trim Navs'
      migration_template "create_navs.rb", "db/migrate/create_navs.rb"

      say "Added navigation migration to db/migrate.rb", MESSAGE_COLOR
    end

    def add_navigation_filter_to_routes
      route("filter :navigation")

      say "Added navigation filter to config/routes.rb", MESSAGE_COLOR
    end

    def create_pages
      sleep(2)
      puts 'Installing Trim Pages'
      migration_template "create_pages.rb", "db/migrate/create_pages.rb"

      say "Added pages migration to db/migrate", MESSAGE_COLOR
    end

    def add_route_for_pages
      route("resources :pages, :only => :show")

      say "Added pages routes to config/routes.rb", MESSAGE_COLOR
    end

    def create_lead_images
      sleep(2)
      puts 'Installing Trim Lead Images'
      migration_template "create_lead_images.rb", "db/migrate/create_lead_images.rb"

      say "Added pages migration to db/migrate", MESSAGE_COLOR
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
    end

    def build_default_nav
      Nav.rebuild_navs!
    end
  end
end