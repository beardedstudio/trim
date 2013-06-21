require 'active_support/dependencies'
require 'devise'
require 'rails_admin'
require 'cancan'
require "active_support/dependencies"
require "devise"
require "rails_admin"
require "cancan"
require "paper_trail"

module Trim
  require 'trim/railtie' if defined?(Rails)

  require 'trim/rails_admin/rails_admin_multi_enum.rb'
  require 'trim/rails_admin/rails_admin_nested_sort.rb'
  require 'trim/rails_admin/rails_admin_reorder.rb'
  require 'trim/rails_admin/rails_admin_settings.rb'
  require 'trim/rails_admin/rails_admin_show_in_app.rb'
  require 'trim/rails_admin/rails_admin_single_hierarchy.rb'

  def self.setup
    yield self
  end
end

require 'trim/engine'
