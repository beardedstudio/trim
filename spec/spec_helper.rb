ENV['RAILS_ENV'] ||= 'test'

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require 'rspec/rails'

require 'trim'
require 'capybara/rails'
require 'capybara/rspec'
require 'rspec/autorun'
require 'database_cleaner'
require 'support/database_cleaner'
require 'support/garbage_collection'
require 'support/paperclip'
require 'support/devise'
require 'paperclip/matchers'
require 'dummy/config/environment'

Rails.backtrace_cleaner.remove_silencers!

Dir[Rails.root.join("#{File.dirname(__FILE__)}/support/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = false
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"

  config.include Rails.application.routes.url_helpers, :type => :routing

  unless ENV['ALL']
    config.filter_run_excluding :js => true
  end

  config.before :suite do
    load Rails.root.join('db/seeds.rb')
  end

  def testing_image_path
    "../support/test-image.jpg"
  end

  def get_testing_image
    File.new Rails.root.join(testing_image_path)
  end
end
