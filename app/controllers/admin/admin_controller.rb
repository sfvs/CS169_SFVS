class Admin::AdminController < ApplicationController

  def index
    @users = User.find(:all, :conditions => ["admin = ?", false])
    authorize current_user, :is_admin?
  end

  def show
    @user = User.find(params[:id])
    authorize current_user, :is_admin?
  end

  def edit
    @user = User.find(params[:id])
    authorize current_user, :is_admin?
  end

  def create
    authorize current_user, :is_admin?
  end

  def destroy
    @user = User.find(params[:id])
    authorize current_user, :is_admin?
    @user.destroy
    flash[:notice] = "User #{@user.email} has been removed."
    redirect_to admin_root_path
  end

end
