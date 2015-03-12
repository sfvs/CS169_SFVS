class UsersController < ApplicationController

  def show
    if User.exists?(params[:id])
      @user = User.find(params[:id])
      authorize current_user, :is_regular_user?
      authorize @user, :is_profile_owner?
    else
      redirect_to root_path
    end
  end
end
