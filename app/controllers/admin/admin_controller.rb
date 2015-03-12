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
    @user.destroy
    flash[:notice] = "User #{@user.email} has been removed."
    authorize current_user
  end
end
