require 'active_support/dependencies'
require 'routing-filter'
require 'inherited_resources'
require 'devise'
require 'cancan'
require 'rails_admin'
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
  require 'trim/models/has_lead_items.rb'
  require 'trim/models/has_images.rb'
  require 'trim/models/has_downloads.rb'
  require 'trim/models/has_videos.rb'
  require 'trim/models/has_related_items.rb'
  require 'trim/models/rails_admin_default_i18n.rb'

  # Renderers
  require 'trim/liquid/tags/image.rb'
  require 'trim/liquid/tags/download.rb'
  require 'trim/liquid/tags/video.rb'

  def self.setup
    yield self
  end
end

require 'generators/trim/trim_generator'
require 'trim/engine'
