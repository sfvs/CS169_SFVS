class UsersController < ApplicationController

  before_filter :require_valid_user

  def show
    @user = User.find(params[:id])
    @application = @user.get_most_recent_application
    if @application
      @completed_forms = @application.get_completed_forms
      if @application.completed
        @status = "Complete"
      else
        @status = "Incomplete"
      end
      @year = @application.year
      @type = @application.application_type.app_type
      @forms_to_build = @application.application_type.forms
    end
  end

  def submit_application
    user = User.find(params[:id])
    application = user.get_most_recent_application
    if application and application.all_forms_completed? and not application.completed
      application.completed = true
      application.save
    end
    redirect_to user_path(user)
  end

end
