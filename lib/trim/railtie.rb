require 'trim'
require 'rails'
require 'trim/helpers/navigation_helper'

module Trim
  class Railtie < Rails::Railtie
    railtie_name :trim

    rake_tasks do
      load "tasks/trim.rake"
    end

    initializer "trim.helpers.navigation_helper" do
      ActionView::Base.send :include, Helpers::NavigationHelper
    end
  end
end