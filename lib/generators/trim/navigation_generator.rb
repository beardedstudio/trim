module Trim

  class NavigationGenerator < TrimGenerator

    include Rails::Generators::Migration

    source_root File.expand_path('../../templates', __FILE__)

    def self.next_migration_number(path)
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    end

    def create_navs
      sleep(2)
      migration_template "create_navs.rb", "db/migrate/create_navs.rb"

      say "Added navigation migration to db/migrate.rb", MESSAGE_COLOR
    end

    def install_routing_filter
      directory 'routing_filter', 'lib/routing_filter'

      require_code = '    config.autoload_paths +=%W(#{config.root}/lib/routing_filter)'

      insert_into_file 'config/application.rb', require_code, :after => "extras)\n"
    end
  end
end