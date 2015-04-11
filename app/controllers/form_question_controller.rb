class FormQuestionController < ApplicationController

  def show
    @form_type = params[:type]
    logger.debug "params #{params[:form_answer]}"
    @list_of_questions = FormQuestion.get_questions_for_form(@form_type)
  	if (params[:submit]) 
      if form_completed?
        flash[:notice] = "#{@form_type} successfully submitted."
      	redirect_to user_path()
      else
      	@error = "Please complete the form before submitting."
      end
    # elsif (params[:save])
    #   save_progress
    #   flash[:notice] = "#{@form_type} successfully saved."
    #   redirect_to user_path()
    end
  end

  def save_progress
    # logger.debug "params #{params[:form_answer]}"
    # Converting the answers into hash key = form questions, value = answers
    # logger.debug "form_type #{params[:type]}"
    @questions_list = FormQuestion.get_list_of_questions(params[:type])
    @form_content = {
      params[:type] => Hash[@questions_list.zip get_answers]
    }
    logger.debug "form_content #{@form_content}"
    # logger.debug "user #{params[:id]}"
    @user = User.find(params[:id])
    @application = @user.get_most_recent_application
    @application.content = @application.content.merge(@form_content)
    @application.save!
    logger.debug "application #{@application.content}"
    flash[:notice] = "#{params[:type]} successfully saved."
    redirect_to user_path
  end

  private
  #filter that check if the form is filled correctly
  def form_completed?
  	true
  end
  
  # Form an array of answers using the params
  def get_answers
    answers_list = []
    params[:form_answer].each do |key, value|
      answers_list << value
    end
    answers_list
  end
end
