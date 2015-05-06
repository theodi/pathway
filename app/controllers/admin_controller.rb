class AdminController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    authorize! :manage, :users
    @users = User.all.order(created_at: :asc)
  end
        
end
