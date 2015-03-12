class Admin::AdminController < ApplicationController
  def index
    @users = User.find(:all, :conditions => ["admin = ?", false])
    authorize current_user
  end

  def show
    @user = User.find(params[:id])
    authorize current_user
  end

  def edit
    @user = User.find(params[:id])
    authorize current_user
  end

  def create
    authorize current_user
  end

  def destroy
    @user = User.find(params[:id])
    authorize current_user
    @user.destroy
    flash[:notice] = "User #{@user.email} has been removed."
    redirect_to admin_root_path
  end
end
