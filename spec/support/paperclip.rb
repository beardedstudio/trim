RSpec.configure do |config|
  config.before :each do
    AWS.config  :bucket => ENV['AWS_BUCKET'],
                :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
                :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
                :stub_requests => true
  end
end
