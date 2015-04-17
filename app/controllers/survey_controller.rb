class SurveyController < ApplicationController

  before_filter :require_valid_user
  
  def questionnaire
    # @display is an array of hashes, containing question and its answers 
    # as Rows in Table Answers. something like, 
    # [{:question => "What's my name?", :answer => AnswersTable},...]
    @user = User.find_by_id(params[:id])
    @current_selected_answers = [] # to hilite selected answers
    @end_of_questionnaire = false	#set default value
    current_qid = Questionnaire.get_root_question_id
    selected_answer = Answers.find_by_id(params[:ans])

    unless selected_answer.nil? # got an answer
      if selected_answer.is_last_answer?
        @end_of_questionnaire = true
        @current_selected_answers.push(selected_answer.id) #corner case: add the last selected answer into array
        @results = selected_answer.results_to
        current_qid = selected_answer.questionnaire_id
      else	# selected_answer is an intermidate answer
        current_qid = selected_answer.leads_to
      end
    end

    @display_questions = populate_display current_qid

  end

  def submit_questionnaire
    @user = User.find_by_id(params[:id])
    response = "Error. Please try survey again or contact SFVS."
    answer_id = params[:results]
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
    flash[:notice] = response
    redirect_to user_path(@user)
  end

  private

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

end
