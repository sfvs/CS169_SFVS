class Admin::AdminController < ApplicationController

  before_filter :require_admin

  def index
    @users = User.find(:all, :conditions => ["admin = ?", false])
    @forms = Form.find(:all)
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:notice] = "User #{@user.email} has been removed."
    redirect_to admin_root_path
  end

  private

  def require_admin
    authorize current_user, :is_admin?
  end

end
