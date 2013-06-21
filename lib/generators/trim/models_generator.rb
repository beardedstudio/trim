require 'rails/generators'
require 'rails/generators/active_record'
    
module Trim
  # This generator adds a migration for the User model
  class ModelsGenerator < Rails::Generators::Base
    include Rails::Generators::Migration
    source_root File.expand_path('../../templates', __FILE__)
    
    def self.next_migration_number(path)
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    end 

    def install_cancan(*args)
      puts 'Installing Cancan'
      generate 'cancan:ability'

      code = <<-code
      
    user ||= User.new
    can :manage, :all if user.persisted?        
      code

      insert_into_file 'app/models/ability.rb', code, :after => 'def initialize(user)'
    end

    def create_friendly_id_history_table
      sleep(2)
      puts 'Installing Friendly Id'
      generate 'friendly_id'
    end

    def create_navs
      sleep(2)
      puts 'Installing Trim Navs'
      migration_template "create_navs.rb", "db/migrate/create_navs.rb"
    end

    def add_navigation_filter_to_routes
      route("filter :navigation")
    end

    def create_pages
      sleep(2)
      puts 'Installing Trim Pages'
      migration_template "create_pages.rb", "db/migrate/create_pages.rb"
    end

    def add_route_for_pages
      route("resources :pages, :only => :show")
    end

  end
end