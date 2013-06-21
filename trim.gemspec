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

  s.add_dependency 'devise'
  s.add_dependency 'cancan'
  s.add_dependency 'rails_admin'
  s.add_dependency 'haml-rails'
  s.add_dependency 'awesome_nested_set'
  s.add_dependency 'rubytree'
  s.add_dependency 'friendly_id'
  s.add_dependency 'paper_trail'
end