class Admin::AdminController < ApplicationController
  # include UsersHelper # Perhaps need to create the same method in AdminHelper and include it?

  def index
    @users = User.find(:all, :conditions => ["admin = ?", false])
    authorize current_user
  end

  def show
    @user = User.find_by_id(params[:id])
    if @user.nil?
      redirect_to admin_root_path
      return
    end
    authorize current_user
  end

  def edit
    @user = User.find_by_id(params[:id])
    if @user.nil?
      redirect_to admin_root_path
      return
    end
    authorize current_user
  end

  def create
    authorize current_user
  end

  def destroy
    authorize current_user
  end
end
