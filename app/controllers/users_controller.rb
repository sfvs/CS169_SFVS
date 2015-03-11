class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    authorize current_user, :is_regular_user?
    authorize @user, :is_profile_owner?
  end
end
