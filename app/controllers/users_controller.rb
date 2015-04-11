class UsersController < ApplicationController

  before_filter :require_valid_user

  def show
    @user = User.find(params[:id])
    flash[:notice] = parse_questionnaire_response(flash[:questionnaire_response])
    @application = @user.get_most_recent_application
    if @application
      if @application.completed
        @status = "Completed"
      else
        @status = "Incompleted"
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

  def parse_questionnaire_response(answer_id)
    response = "Error"
    if answer_id != nil
      type = ApplicationType.find_by_id(answer_id.to_i)
      unless type.nil?
        response = "Your type is #{type.app_type}."
        recent_application = @user.get_most_recent_application
        if not recent_application.nil?
          recent_application.destroy
        end
        app = @user.applications.create()
        app.application_type = type
        app.year = Application.current_application_year
        app.save
      end
      response
    end
  end

end
