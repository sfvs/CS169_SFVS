class Admin::UsersController < Admin::AdminController

  require 'will_paginate/array'

  before_filter :require_admin
  before_filter :pressed_cancel?, :only => [:create, :update]

  def index
    # Check order of users params[:order]
    # Call a User model method to return a sorted list of users 
    @users = User.get_users_by_order(params[:order]).paginate(:page => params[:page], :per_page => 10)
    gon.push({
      :emails => User.get_all_email_in_text(@users)
      })
  end

  def show
    @user = User.find(params[:id])
    # List the forms for the user
    @applications = @user.applications.order(year: :desc)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update_attributes(params[:user])
    flash[:notice] = "User #{@user.email} has been updated."
    redirect_to admin_user_path(@user)
  end

  def create
    valid_email = User.valid_email?(params[:user][:email])
    if valid_email && params[:user][:password].length >= 8
      user = User.create(params[:user], :without_protection => true)
      user.skip_confirmation!
      user.save!
      flash[:notice] = "New user created"
      redirect_to admin_users_path
    else
      flash[:alert] = valid_email == false ? "E-mail already taken" : "Password needs to be atleast 8 characters long."
      redirect_to new_admin_user_path
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:notice] = "User #{@user.email} has been removed."
    redirect_to admin_users_path
  end

  def search
    @user = User.where("email=? and admin=?", params[:user_email], false).first
    if @user.nil?
      flash[:alert] = "No user with e-mail: #{params[:user_email]}"
      redirect_to admin_users_path
      return
    end
    redirect_to admin_user_path(@user)
    return
  end

  def filter
    @users = User.get_users_filtered_by(params[:app_year]).paginate(:page => params[:page], :per_page => 10)
    gon.push({
      :emails => User.get_all_email_in_text(@users)
      })
    render :index
    return
  end

  def pressed_cancel?
    if params[:commit] == 'Cancel'
      redirect_to admin_user_path(params[:id])
    end
  end
end
