class UsersController < ApplicationController

  before_filter :require_valid_user

  def show
    @user = User.find(params[:id])
    flash[:notice] = parse_questionnaire_response(params[:questionnaire_response])
    @application = @user.get_most_recent_inprogress_application
  end

  private

  def parse_questionnaire_response(answer_id)
    response = "Error"
    if answer_id != nil
      type = ApplicationType.find_by_id(answer_id.to_i)
      unless type.nil?
        response = "Your type is #{type.app_type}."
        recent_application = @user.get_most_recent_inprogress_application
        if not recent_application.nil?
          recent_application.destroy
        end
        app = @user.applications.create()
        app.application_type = type
        app.save
      end
      response
    end
  end

end
