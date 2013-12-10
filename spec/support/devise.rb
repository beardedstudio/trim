# What it says: https://github.com/plataformatec/devise/wiki/Speed-up-your-unit-tests
Devise.setup do |config|
  config.stretches = 1
end

RSpec.configure do |config| 

  config.include Devise::TestHelpers, :type => :controller
  
  # Warden test helper for logging in in tests
  config.include Warden::Test::Helpers, :type => :controller
    config.after(:each, :type => :controller) do
    Warden.test_reset!
  end
end
