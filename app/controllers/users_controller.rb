class UsersController < ApplicationController

  def show
    @user = User.find_by_id(params[:id])
    if @user.nil?
      redirect_to root_path
    end
    authorize current_user, :is_regular_user?
    authorize @user, :is_profile_owner?
  end
end
