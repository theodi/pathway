class AdminController < ApplicationController
before_filter :authenticate_user!, :ensure_admin!
  
  def index
    #@users = User.find(:all)
    @users = User.all
  end
  
  private

  def ensure_admin!
    unless current_user.admin?
      sign_out current_user
      redirect_to root_path
      return false
    end
  end
      
end
