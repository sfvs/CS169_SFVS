class HomeController < ApplicationController
  def index
    if current_user.admin?
      redirect_to admin_users_path
    else
      redirect_to user_path(current_user)
    end
  end
end
