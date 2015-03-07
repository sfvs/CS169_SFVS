class HomeController < ApplicationController

	def index
		#just render index page
		if user_signed_in?
			redirect_to user_path(current_user)
		else
			redirect_to new_user_session_path
    else
      if current_user.admin?
        redirect_to admin_path
      end
		end
	end

end
