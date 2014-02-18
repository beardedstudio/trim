module Trim
  class InheritedController < TrimController
    inherit_resources
    before_filter :add_to_editables, :only => :show
  end
end
