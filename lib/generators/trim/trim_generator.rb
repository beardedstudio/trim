require 'rails/generators'

module Trim

  class TrimGenerator < Rails::Generators::Base
    MESSAGE_COLOR = :yellow
    ERROR_COLOR = :red
    SUCCESS_COLOR = :green
  end

end