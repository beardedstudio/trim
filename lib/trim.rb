require 'active_support/dependencies'
require 'routing-filter'
require 'inherited_resources'
require 'devise'
require 'cancan'
require 'rails_admin'
require 'rails_admin_nestable'
require 'active_support/dependencies'
require 'friendly_id'
require 'paperclip'
require 'aws-sdk'
require 'ckeditor'
require 'formtastic'
require 'jquery_ui_rails_helpers'
require 'compass-rails'
require 'breakpoint'
require 'liquid'

module Trim
  require 'trim/railtie' if defined?(Rails)

  require 'trim/version'

  # Rails Admin custom actions
  require 'trim/rails_admin/rails_admin_multi_enum.rb'
  require 'trim/rails_admin/rails_admin_settings.rb'
  require 'trim/rails_admin/rails_admin_show_in_app.rb'

  # Mixins
  require 'trim/models/has_excerpt.rb'
  require 'trim/models/has_nav_items.rb'
  require 'trim/models/has_lead_items.rb'
  require 'trim/models/has_images.rb'
  require 'trim/models/has_downloads.rb'
  require 'trim/models/has_videos.rb'
  require 'trim/models/has_related_items.rb'
  require 'trim/models/rails_admin_default_i18n.rb'
  require 'trim/models/renderer.rb'

  # Renderers
  require 'trim/liquid/tags/image.rb'
  require 'trim/liquid/tags/download.rb'
  require 'trim/liquid/tags/video.rb'

  # Routing Filter
  require 'trim/routing_filter/navigation.rb'

  require 'trim/test_helper'

  # Configuration

  # Image styles for paperclip resizing
  mattr_accessor :image_styles
  @@image_styles = { :thumb => "300x200>",
                     :lead  => "1000x200#" }

  mattr_accessor :image_default_convert_option
  @@image_default_convert_option = '-strip -interlace Plane -quality 85'

  mattr_accessor :image_convert_options
  @@image_convert_options = {}

  def self.image_convert_options
    @@image_styles.each do |k, _|
      @@image_convert_options[k] = @@image_default_convert_option unless @@image_convert_options.key?(k)
    end

    @@image_convert_options
  end

  mattr_accessor :setting_email_keys
  @@setting_email_keys = { }

  mattr_accessor :navs
  @@navs = [ ]

  mattr_accessor :navigable_routes
  @@navigable_routes = { }

  mattr_accessor :additional_settings
  @@additional_settings = [ ]

  mattr_accessor :attr_accessible_role
  @@attr_accessible_role = :default

  def self.setup
    yield self
  end

  def self.table_name_prefix
    'trim_'
  end

  def self.use_relative_model_naming?
    true
  end

end

require 'generators/trim/trim_generator'
require 'trim/engine'
