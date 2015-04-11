class Admin::UsersController < Admin::AdminController
  before_filter :require_admin

  def index
    @users = User.where(admin: false).paginate(:page => params[:page], :per_page => 10)
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

  def search
    @user = User.where(email: params[:user_email][:email], admin: false).first
    if @user.nil?
      flash[:alert] = "No user with e-mail: #{params[:user_email][:email]}"
      redirect_to admin_users_path
      return
    end
    redirect_to admin_user_path(@user)
    return
  end
end
