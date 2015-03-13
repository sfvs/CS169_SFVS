class UsersController < ApplicationController

  before_filter :require_valid_user

  def show
    @user = User.find(params[:id])
    @response = parse_questionnaire_response(params[:questionnaire_response])
  end

  def questionnaire
    @@ROOT_QUESTION_ID = 1

    # @display is an array of hashes, containing question and its answers 
    # as Rows in Table Answers. something like, 
    # [{:question => "What's my name?", :answer => AnswersTable},...]
    @display = Array.new {Hash.new}
    @selected_a_id = []
    @end_of_questionnaire = false	#set default value
    current_qid = @@ROOT_QUESTION_ID	#base case, at root question
    if params[:ans] != nil	#got an answer
      a = Answers.find(params[:ans])
      if a.leads_to == nil	#case1: a is the last answer
        @end_of_questionnaire = true
        @selected_a_id.push(a.id) #corner case: add the last selected answer into array
        @form = a.id
        current_qid = a.questionnaire_id
      else	#case2: a is an intermidate answer
        current_qid = a.leads_to
      end
    end

    while current_qid != nil	#populate @display with q/a pairs
      q = Questionnaire.find(current_qid)
      as = Answers.where(questionnaire_id: current_qid)
      @display.unshift({:question => q.question, :answer => as})
      if current_qid != 1
        @selected_a_id.push(Answers.get_answer_id(q.id, q.parent_id)) 
      end
      current_qid = q.parent_id
    end
  end

  private
  
  def require_valid_user
    #if used everywhere, we should put in application controller
    authorize User.find(params[:id]), :is_profile_owner?
    authorize current_user, :is_regular_user?
  end

  def parse_questionnaire_response(answer_id)
    if answer_id != nil
      if answer_id == "3"
        "Good choice"
      elsif answer_id == "4"
        "Hmmmmm"
      elsif answer_id == "5"
        "Ewwwwww"
      elsif answer_id == "6"
        "I knew it!"
      elsif answer_id == "7"
        "Cool"
      elsif answer_id == "8"
        "MANGO HABANERO"
      elsif answer_id == "9"
        "So you like to be second."
      else
        "" #default response is empty
      end
    end
  end

end
