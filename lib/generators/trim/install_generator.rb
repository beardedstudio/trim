require 'rails/generators'
require 'rails/generators/active_record'

module Trim
  # This generator adds a migration for the User model
  class InstallGenerator < Rails::Generators::Base

    def install
      generate 'trim:models'
      generate 'trim:admin'
    end

    def fix_sass_compass_rails4
      rails4_compass_gem = "gem 'compass-rails', github: 'Compass/compass-rails', branch: 'rails4-hack'\n"
      insert_into_file 'Gemfile', rails4_compass_gem, :before => 'group :doc'
      system 'bundle install'
    end
  end
end
