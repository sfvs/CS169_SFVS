class FormQuestionController < ApplicationController
  
  include ApplicationHelper

  def show
    @form_type = params[:type]
    @list_of_questions = FormQuestion.get_questions_for_form(@form_type)
    application = User.find(params[:id]).get_most_recent_application
    if application
      @saved_form = application.content
      if @saved_form.has_key?(@form_type)
        @form_answer = get_answers_to_prefill_from(@saved_form[@form_type], @form_type)
      end
    end
  end

  def save_progress
    @user = User.find(params[:id])
    @form_content = get_form_content
    @application = @user.get_most_recent_application
    if params[:commit] == "Save and Return"
      update_application(false)
      flash[:notice] = "#{params[:type]} successfully saved."
      redirect_to user_path(@user)
    elsif params[:commit] == 'Submit'
      submit
    end
  end

  #filter that check if the form is filled correctly
  def form_completed?
  	!(@form_content[params[:type]].has_value?("") || @form_content[params[:type]].has_value?(nil))
  end
  
  # Form an array of answers using the params
  def get_answers
    answers_list = []
    params[:form_answer].each do |key, value|
      answers_list << value
    end
    answers_list
  end

  def get_form_content
    @questions_list = FormQuestion.get_list_of_questions(params[:type])
    form_content = {
      params[:type] => Hash[@questions_list.zip get_answers]
    }
    form_content
  end

  def update_application(completed)
    @form_content[params[:type]][:completed] = completed
    @application.add_content(@form_content)
  end

  def submit
    if form_completed?
        update_application(true)
        flash[:notice] = "Submitted #{params[:type]}"
        redirect_to user_path(@user)
      else
        flash[:alert] = "There are missing fields in the form"
        @list_of_questions = FormQuestion.get_questions_for_form(params[:type])
        @form_type = params[:type]
        @form_answer = params[:form_answer]
        render :show
      end
  end
end
