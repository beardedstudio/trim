$:.push File.expand_path("../lib", __FILE__)
require "trim/version"

Gem::Specification.new do |s|
  s.name        = 'trim'
  s.version     = Trim::VERSION
  s.platform    = Gem::Platform::RUBY
  s.email       = 'info@bearded.com'
  s.homepage    = 'http://github.com/beardedstudio/trim'
  s.date        = '2013-11-26'
  s.summary     = "A lightweight rails CMS"
  s.description = "A lightweight rails CMS by Bearded."
  s.authors     = ["Brett Bender", "Mark Frey", "Patrick Fulton", "Dominic Dagradi"]
  s.files       = `git ls-files`.split("\n")
  s.require_paths = ['lib']

  s.add_dependency 'rails', '~> 3.2.16'
  s.add_dependency 'ancestry', '~> 2.0.0'
  s.add_dependency 'aws-sdk', '~> 1.29.1'
  s.add_dependency 'breakpoint', '~> 2.0.7'
  s.add_dependency 'cancan', '~> 1.6.10'
  s.add_dependency 'ckeditor', '~> 4.0.6'
  s.add_dependency 'devise', '~> 3.2.2'
  s.add_dependency 'formtastic', '~> 2.2.1'
  s.add_dependency 'friendly_id', '~> 4.0.10.1'
  s.add_dependency 'haml-rails', '~> 0.4'
  s.add_dependency 'inherited_resources', '~> 1.4.1'
  s.add_dependency 'jquery_ui_rails_helpers', '~> 0.0.4'
  s.add_dependency 'liquid', '~> 2.6.0'
  s.add_dependency 'paperclip', '~> 3.5.2'
  s.add_dependency 'rails_admin', '~> 0.4.9'
  s.add_dependency 'rails_admin_nestable', '~> 0.1.7'
  s.add_dependency 'routing-filter', '~> 0.3.1'
  s.add_dependency 'sass-rails', '~> 3.2.6'
  s.add_dependency 'compass-rails', '~> 1.1.2'
  s.add_dependency 'liquid', '~> 2.6.0'
  s.add_dependency 'ruby-oembed', '~> 0.8.9'

  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'machinist'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'colored'
  s.add_development_dependency 'sqlite3'

  s.test_files = Dir["spec/**/*"]

end