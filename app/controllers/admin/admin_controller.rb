class Admin::AdminController < ApplicationController

  def index
    @users = User.find(:all, :conditions => ["admin = ?", false])
    authorize current_user
  end

  def show
    if User.exists?(params[:id])
      @user = User.find(params[:id])
      authorize current_user
    else
      redirect_to admin_root_path
    end
  end

  def edit
    if User.exists?(params[:id])
      @user = User.find(params[:id])
      authorize current_user
    else
      redirect_to admin_root_path
    end
  end

  def create
    authorize current_user
  end

  def destroy
    authorize current_user
  end
end
