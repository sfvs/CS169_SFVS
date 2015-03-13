class UsersController < ApplicationController
  def show
    @user = User.find_by_id(params[:id])
    authorize current_user, :is_regular_user?
    authorize @user, :is_profile_owner?
    @response = ""
    if params[:form] != nil
      aid = params[:form]
      if aid == "3"
        @response = "Good choice"
      elsif aid == "4"
        @response = "Hmmmmm"
      elsif aid == "5"
        @response = "Ewwwwww"
      elsif aid == "6"
        @response = "I knew it!"
      elsif aid == "7"
        @response = "Cool"
      elsif aid == "8"
        @response = "MANGO HABANERO"
      elsif aid == "9"
        @response = "So you like to be second."
      end
    end 
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
end
