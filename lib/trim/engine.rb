module Trim

  class Engine < Rails::Engine

    config.to_prepare do
      Dir.glob(Rails.root + "app/decorators/**/*_decorator*.rb").each do |c|
        require_dependency(c)
      end
    end

    # Enabling assets precompiling under rails 3.1+
    if Rails.version >= '3.1'
      initializer 'Trim Assets', :group => :all do |app|
        app.config.assets.precompile += %w[ modernizr-custom.min.js
                                            trim/trim.js
                                            trim/trim.css
                                            trim/errors.css
                                            trim/no-mq.css
                                            trim/admin-bar.css ]
      end
    end

    config.generators do |g|
      g.test_framework      :rspec,        :fixture => false
      g.assets false
      g.helper false
    end
  end

end