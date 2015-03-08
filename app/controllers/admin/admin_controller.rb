class Admin::AdminController < ApplicationController
  def index
    @users = User.find(:all, :conditions => ["admin = ?", false])
  end

  def show
    @user = User.find(params[:id]) # Could probably use current_user
  end

  def edit
    @user = User.find(params[:id]) # Could probably use current_user
  end

  def create

  end

  def destroy

  end
end
