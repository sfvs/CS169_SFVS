class HomeController < ApplicationController

  skip_before_filter :authenticate_user!, :only => :index

  def index
    flash.keep
    if user_signed_in?
      if current_user.admin?
        redirect_to admin_root_path
      else
        redirect_to user_path(current_user)
      end
    else
      redirect_to new_user_session_path
    end
  end
  
end
