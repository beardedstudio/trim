module Trim

  class Engine < Rails::Engine
    isolate_namespace Trim

    config.to_prepare do
      Dir.glob(Rails.root + "app/decorators/**/*_decorator*.rb").each do |c|
        require_dependency(c)
      end
    end

    # Enabling assets precompiling under rails 3.1+
    if Rails.version >= '3.1'
      initializer 'Trim Assets', :group => :all do |app|
        app.config.assets.precompile += %w[ trim/trim.js
                                            trim/trim.css
                                            trim/errors.scss
                                            trim/no-mq.scss
                                            trim/admin-bar.scss ]
      end
    end

    config.generators do |g|
      g.test_framework      :rspec,        :fixture => false
      g.assets false
      g.helper false
    end
  end

end