class BaseAdminController < ApplicationController
  before_filter :authenticate_user!, :ensure_admin!
    
  private

  def ensure_admin!
    unless current_user.admin?
      sign_out current_user
      redirect_to root_path
      return false
    end
  end
      
end
