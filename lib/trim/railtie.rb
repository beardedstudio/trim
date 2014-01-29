require 'trim'
require 'rails'

module Trim
  class Railtie < Rails::Railtie
    railtie_name :trim

    rake_tasks do
      load "tasks/trim.rake"
    end

    config.after_initialize do

      if ActiveRecord::Base.connection.table_exists? 'trim_navs'
        Trim::Nav.configure
      end
    end
  end
end