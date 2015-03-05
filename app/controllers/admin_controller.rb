class AdminController < BaseAdminController
  
  def index
    #@users = User.find(:all)
    @users = User.all
  end
        
end
