class UsersController < ApplicationController

  before_filter :require_valid_user

  def show
    @user = User.find(params[:id])
    @response = parse_questionnaire_response(params[:questionnaire_response])
 end

  def questionnaire
    # @display is an array of hashes, containing question and its answers 
    # as Rows in Table Answers. something like, 
    # [{:question => "What's my name?", :answer => AnswersTable},...]

    @current_selected_answers = [] # to hilite selected answers
    @end_of_questionnaire = false	#set default value
    current_qid = Questionnaire.get_root_question_id

    unless params[:ans].nil? # got an answer
      selected_answer = Answers.find(params[:ans])
      if selected_answer.is_last_answer?
        @end_of_questionnaire = true
        @current_selected_answers.push(selected_answer.id) #corner case: add the last selected answer into array
        @application_type = selected_answer.id
        current_qid = selected_answer.questionnaire_id
      else	# selected_answer is an intermidate answer
        current_qid = selected_answer.leads_to
      end
    end

    @display_questions = populate_display current_qid

  end

  private

  def require_valid_user
    #if used everywhere, we should put in application controller
    authorize User.find(params[:id]), :is_profile_owner?
    authorize current_user, :is_regular_user?
  end

  # make an array of with q/a pairs for display, also edites current_select_answers
  def populate_display(current_qid)
    questions = Array.new {Hash.new}
    while current_qid != nil
      current_question = Questionnaire.find(current_qid)
      associated_answer = Answers.get_answer_from current_question

      # put question to front so it is in order from first to last question
      questions.unshift({:question => current_question.question, :answer => associated_answer})
      if current_qid != Questionnaire.get_root_question_id # root question has no parent question
        @current_selected_answers.push(Answers.get_answer_leading_to(current_question).id) 
      end

      current_qid = current_question.parent_id
    end
    questions
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
