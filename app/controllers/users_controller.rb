class UsersController < ApplicationController
  def show
   #@user = params[:id]
    @user = User.find_by_id(params[:id])
  end
end
