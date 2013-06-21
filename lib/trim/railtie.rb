require 'trim'
require 'rails'

module Trim
  class Railtie < Rails::Railtie
    railtie_name :trim

    rake_tasks do
      load "tasks/trim.rake"
    end
  end
end