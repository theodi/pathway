class RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters

  def new
    super
  end

  def create
    build_resource(sign_up_params)
    resource_saved = resource.save
    yield resource if block_given?
    if resource_saved
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      @validatable = devise_mapping.validatable?
      if @validatable
        @minimum_password_length = resource_class.password_length.min
      end
      
      if resource.errors.include?(:organisation_id)
        redirect_to contact_organisation_admin_path(resource.organisation_id, email: resource.email)
      else
        respond_with resource
      end
    end
  end

  def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) do |u|
        u.permit(:name,
          :email, :password, :password_confirmation, :associated_organisation, :terms_of_service)
      end 
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:name,
        :email, :password, :password_confirmation, :current_password, :associated_organisation, :terms_of_service, :name)
    end
  end
    
end