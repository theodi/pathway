class UserController < BaseAdminController
  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    params[:user].delete(:password) if params[:user][:password].blank?
    params[:user].delete(:password_confirmation) if params[:user][:password].blank? and params[:user][:password_confirmation].blank?
    puts params[:user]
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated User."
      redirect_to "/admin"
    else
      render :action => 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      flash[:notice] = "Successfully deleted User."
      redirect_to "/admin"
    end
  end

end
