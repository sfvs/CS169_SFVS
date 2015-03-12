class Admin::AdminController < ApplicationController

  def index
    @users = User.find(:all, :conditions => ["admin = ?", false])
    authorize current_user
  end

  def show
    show_and_edit
  end

  def edit
    show_and_edit
  end

  def create
    authorize current_user
  end

  def destroy
    authorize current_user
  end

  private
  def show_and_edit
    if User.exists?(params[:id])
      @user = User.find(params[:id])
      authorize current_user
    else
      redirect_to admin_root_path
    end
  end
end
