class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?

  def index
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :associated_organisation
    devise_parameter_sanitizer.for(:account_update) << :associated_organisation
    devise_parameter_sanitizer.for(:sign_up) << :name
    devise_parameter_sanitizer.for(:account_update) << :name
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to(root_url, {:flash => { :alert => exception.message }})
  end

  def after_sign_in_path_for(resource)
    if current_user.associated_country.blank?
      edit_user_registration_path
    else
      assessments_path
    end
  end

  def current_ability
      @current_ability ||= Ability.new(current_user, params[:token])
  end

end
