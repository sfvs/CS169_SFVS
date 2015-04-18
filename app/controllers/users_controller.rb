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
    if application
      if not application.completed #and application.all_forms_completed? 
        application.completed = true
        application.save
        flash[:notice] = "Application successfully submitted."
      # else
      #   flash[:alert] = "One of the forms is not yet submitted."
      # end
    else
      flash[:alert] = "Error. Application not found. Please contact SFVS for help."
    end
    redirect_to user_path(user)
  end

end
