require 'active_support/dependencies'
require 'devise'
require 'rails_admin'
require 'cancan'
require "active_support/dependencies"
require "devise"
require "rails_admin"
require "cancan"
require "routing-filter"
require 'friendly_id'
require 'paperclip'
require 'aws-sdk'

module Trim
  require 'trim/railtie' if defined?(Rails)

  # Rails Admin custom actions
  require 'trim/rails_admin/rails_admin_multi_enum.rb'
  require 'trim/rails_admin/rails_admin_nested_sort.rb'
  require 'trim/rails_admin/rails_admin_reorder.rb'
  require 'trim/rails_admin/rails_admin_settings.rb'
  require 'trim/rails_admin/rails_admin_show_in_app.rb'
  require 'trim/rails_admin/rails_admin_single_hierarchy.rb'

  # Mixins
  require 'trim/models/has_excerpt.rb'
  require 'trim/models/has_nav_items.rb'
  require 'trim/models/rails_admin_default_i18n.rb'
  require 'trim/models/renders_liquid.rb'
  require 'trim/models/has_lead_items.rb'

  def self.setup
    yield self
  end
end

require 'trim/engine'
require 'trim/routing_filter/navigation.rb'
