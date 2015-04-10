class Admin::UsersController < Admin::AdminController
  before_filter :require_admin

  def index
    @users = User.where(admin: false).page(params[:page]).per(10)
  end

  def show
    @user = User.find(params[:id])
    # List the forms for the user
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
    redirect_to admin_users_path
  end
end
