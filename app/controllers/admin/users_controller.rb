class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin
  
  def index
    @users = User.order(:email).page(params[:page]).per(20)
  end

  def toggle_admin
    @user = User.find(params[:id])
    
    if @user == current_user
      redirect_to admin_users_path, alert: 'You cannot change your own admin status.'
      return
    end
    
    if @user.is_admin?
      @user.remove_admin!
      flash[:notice] = "#{@user.email} is no longer an admin."
    else
      @user.make_admin!
      flash[:notice] = "#{@user.email} is now an admin."
    end
    
    redirect_to admin_users_path
  end

  private

  def ensure_admin
    unless current_user.is_admin?
      redirect_to root_path, alert: 'Access denied. Admin privileges required.'
    end
  end
end
