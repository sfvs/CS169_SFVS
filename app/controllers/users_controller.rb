class UsersController < ApplicationController

  before_filter :require_valid_user

  def show
    @user = User.find(params[:id])
    @application = @user.get_most_recent_application
    if @application
      @completed_forms = get_completed_forms(@application.content)
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
    # Anthony insert here! check if forms are completed
    application = user.get_most_recent_application
    if application and not application.completed
      application.completed = true
      application.save
    end
    redirect_to user_path(user)
  end

  private

  def get_completed_forms(contents)
    completed_forms = []
    contents.each do |key, value|
      completed_forms << key.to_s if value["completed"]
    end
    completed_forms
  end
end
