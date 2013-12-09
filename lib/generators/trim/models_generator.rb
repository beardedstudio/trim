require 'rails/generators/active_record'

module Trim

  class ModelsGenerator < TrimGenerator

    include Rails::Generators::Migration
    source_root File.expand_path('../../templates', __FILE__)

    def self.next_migration_number(path)
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    end

    def install_cancan(*args)
      say 'Installing Cancan', MESSAGE_COLOR
      generate 'cancan:ability'
    end

    def create_friendly_id_history_table
      sleep(2)
      generate 'friendly_id'

      say "Installed friendly_id", MESSAGE_COLOR
    end

    def create_pages
      sleep(2)
      migration_template "create_pages.rb", "db/migrate/create_pages.rb"

      say "Added pages migration to db/migrate", MESSAGE_COLOR
    end

    def create_lead_images
      sleep(2)
      migration_template "create_lead_images.rb", "db/migrate/create_lead_images.rb"

      say "Added lead images migration to db/migrate", MESSAGE_COLOR
    end

    def create_images
      sleep(2)
      migration_template "create_images.rb", "db/migrate/create_images.rb"

      say "Added images migration to db/migrate", MESSAGE_COLOR
    end

    def create_downloads
      sleep(2)
      migration_template "create_downloads.rb", "db/migrate/create_downloads.rb"

      say "Added downloads migration to db/migrate", MESSAGE_COLOR
    end

    def create_related_items
      sleep(2)
      migration_template "create_related_items.rb", "db/migrate/create_related_items.rb"

      say "Added related items migration to db/migrate", MESSAGE_COLOR
    end

    def create_settings
      sleep(2)
      migration_template 'create_settings.rb', 'db/migrate/create_settings.rb'
      say 'Adding settings migration to db/migrate'
    end

    def remove_index_html
      remove_file "public/index.html"
      remove_file "app/assets/images/rails.png"
    end
  end
end