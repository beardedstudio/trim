class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :initialize_editables

  before_filter :reload_rails_admin, :if => :rails_admin_path?

  rescue_from CanCan::AccessDenied do |exception|
    type = flash[:notice].blank? ? :alert : :notice

    path = if user_signed_in?
      flash[:alert] = "You are not authorized to do that."
      main_app.root_path
    else
      flash[:alert] = "Please log in or sign up for an account first."
      main_app.new_user_session_path
    end

    redirect_to path
  end

  def reload_rails_admin
    models = RailsAdmin::Config.registry.keys
    models.each do |m|
      RailsAdmin::Config.reset_model(m)
    end
    RailsAdmin::Config::Actions.reset

    load("#{Rails.root}/config/initializers/rails_admin.rb")
    models.each do |m|
      m.rails_admin if m.respond_to?(:rails_admin)
    end
  end

  def rails_admin_path?
    controller_path =~ /rails_admin/ && Rails.env == "development"
  end

  def initialize_editables
    @editables ||= []
  end

  def add_to_editables
    @editables << resource
  end

  def after_sign_in_path_for(resource)
    redirect_back_path || super
  end

  def current_ability
    @current_ability ||= Ability.new(current_user, request.session_options[:id])
  end
end
