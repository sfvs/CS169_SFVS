class UsersController < ApplicationController
  include UsersHelper

  def show
    if !user_exists?(params[:id])
      redirect_to root_path
      return
    end
    @user = User.find(params[:id])
    authorize current_user, :is_regular_user?
    authorize @user, :is_profile_owner?
  end
end
