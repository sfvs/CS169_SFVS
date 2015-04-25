class Admin::UsersController < Admin::AdminController

  require 'will_paginate/array'

  before_filter :require_admin
  before_filter :pressed_cancel?, :only => [:create, :update]

  def index
    # Check order of users params[:order]
    # Call a User model method to return a sorted list of users 
    @users = User.get_users_by_order(params[:order]).paginate(:page => params[:page], :per_page => 10)
  end

  def show
    @user = User.find(params[:id])
    # List the forms for the user
    @applications = @user.applications
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
    render :index
    return
  end

  def pressed_cancel?
    if params[:commit] == 'Cancel'
      redirect_to admin_user_path(params[:id])
    end
  end
end
