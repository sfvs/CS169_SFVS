class UsersController < ApplicationController

  before_filter :require_valid_user

  def show
    @user = User.find(params[:id])
    @response = parse_questionnaire_response(params[:questionnaire_response])
  end

  private

  def parse_questionnaire_response(answer_id)
    application_types = Application.get_application_types
    if answer_id != nil 
      if answer_id == application_types[:vendor]
        "You are a Vendor."
      elsif answer_id == application_types[:donor]
        "You are a Donor."
      elsif answer_id == application_types[:restaurant_concessionaire]
        "You are a Restaurant Concessionaire."
      elsif answer_id == application_types[:other]
        "You are Other."
      else
        "Error in response." # default response is empty, should be throwing an exception
      end
    end
  end

end
