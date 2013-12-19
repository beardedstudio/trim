module Trim

  class Engine < Rails::Engine
    isolate_namespace Trim

    config.to_prepare do
      Dir.glob(Rails.root + "app/decorators/**/*_decorator*.rb").each do |c|
        require_dependency(c)
      end
    end

    # Enabling assets precompiling under rails 3.1
    if Rails.version >= '3.1'
      initializer :assets do |config|
        Rails.application.config.assets.precompile += %w( trim.js
                                                          trim.css
                                                          errors.css
                                                          no-mq.css
                                                          admin-bar.scss)
      end
    end

    config.generators do |g|
      g.test_framework      :rspec,        :fixture => false
      g.assets false
      g.helper false
    end
  end

end