require 'active_support/dependencies'
require 'devise'
require 'rails_admin'
require 'cancan'

module Trim

  require 'trim/railtie' if defined?(Rails)

  def self.setup
    yield self
  end

end

require 'trim/engine'
