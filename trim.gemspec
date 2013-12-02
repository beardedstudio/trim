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

  s.add_dependency 'devise', '~> 3.2.2'
  s.add_dependency 'cancan', '~> 1.6.10'
  s.add_dependency 'rails_admin', '~> 0.6.0'
  s.add_dependency 'haml-rails', '~> 0.5.1'
  s.add_dependency 'awesome_nested_set', '~> 2.1.6'
  s.add_dependency 'rubytree', '~> 0.8.3'
  s.add_dependency 'friendly_id', '~> 5.0.1'
  s.add_dependency 'liquid', '~> 2.6.0'
  s.add_dependency 'routing-filter', '~> 0.4.0.pre'
  s.add_dependency 'paperclip'
  s.add_dependency 'aws-sdk'
  s.add_dependency 'ckeditor'

end