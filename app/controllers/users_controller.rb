class UsersController < ApplicationController
	def show
		@user = params[:user]
	end
end
