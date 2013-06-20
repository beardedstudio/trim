require 'active_support/dependencies'
require 'devise'
require 'rails_admin'
require 'cancan'

module Trim

  def self.setup
    yield self
  end

end