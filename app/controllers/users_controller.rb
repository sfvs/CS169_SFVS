class UsersController < ApplicationController

  before_filter :require_valid_user

  def show
    @user = User.find(params[:id])
    @application = @user.get_most_recent_inprogress_application
    flash[:notice] = parse_questionnaire_response(params[:questionnaire_response])
  end

  private

  def parse_questionnaire_response(answer_id)
    application_types = Application.get_application_types
    type = nil

    if answer_id != nil 
      if answer_id == application_types[:vendor]
        response = "You are a Vendor."
        type = :vendor
      elsif answer_id == application_types[:donor]
        response = "You are a Donor."
        type = :donor
      elsif answer_id == application_types[:restaurant_concessionaire]
        response = "You are a Restaurant Concessionaire."
        type = :restaurant_concessionaire
      elsif answer_id == application_types[:other]
        response = "You are Other."
        type = :other
      else
        response = "Error in response." # default response is empty, should be throwing an exception
      end

      unless type.nil?
        app = @user.applications.create(:app_type => type)
      end
      response
    end
  end

end
