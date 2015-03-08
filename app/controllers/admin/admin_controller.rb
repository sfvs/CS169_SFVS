class Admin::AdminController < ApplicationController
  def index
    @users = User.find(:all, :conditions => ["admin = ?", false])
  end

  def show
    @user = User.find(params[:id])
  end

  def create

  end

end
