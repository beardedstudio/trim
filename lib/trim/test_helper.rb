module Trim
  # Trim::TestHelper provides a facility to test controllers in isolation

  module TestHelper
    def self.included(base)
      base.class_eval do
        setup :stub_navigation_methods if respond_to? :setup
      end
    end

    # override redirect_to_canonical
    def stub_navigation_methods
      TrimController.any_instance.stub(:redirect_to_canonical)
      TrimController.any_instance.stub(:set_active_nav_item)
    end

  end
end
