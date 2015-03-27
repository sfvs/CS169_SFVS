class UsersController < ApplicationController

  before_filter :require_valid_user

  def show
    @user = User.find(params[:id])
    @response = parse_questionnaire_response(params[:questionnaire_response])
  end

  private

  def require_valid_user
    #if used everywhere, we should put in application controller
    authorize User.find(params[:id]), :is_profile_owner?
    authorize current_user, :is_regular_user?
  end

  def parse_questionnaire_response(answer_id)
    if answer_id != nil 
      if answer_id == "2" #way not not hard code in answer?
        "You are a Vendor."
      elsif answer_id == "3"
        "You are a Donor."
      elsif answer_id == "4"
        "You are a Restaurant Concessionaire."
      elsif answer_id == "5"
        "You are Other."
      else
        "" #default response is empty, should be throwing an exception
      end
    end
  end

end
