require 'rails/generators'
require 'rails/generators/active_record'

module Trim
  # This generator adds a migration for the User model
  class InstallGenerator < Rails::Generators::Base

    def install
      generate 'trim:models'
      generate 'trim:admin'
    end
  end
end
