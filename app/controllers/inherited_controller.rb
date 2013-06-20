class InheritedController < ApplicationController

  inherit_resources

  load_and_authorize_resource :prepend => true

  before_filter :add_to_editables, :only => :show

end
