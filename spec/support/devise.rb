RSpec.configure do |config|

  config.include Devise::TestHelpers, :type => :controller

  # Warden test helper for logging in in tests
  config.include Warden::Test::Helpers, :type => :controller
    config.after(:each, :type => :controller) do
    Warden.test_reset!
  end
end
