class FormQuestionController < ApplicationController  
  include ApplicationHelper

  before_filter :require_valid_user
  before_filter :validate_accessible_form

  def show
    @user = User.find_by_id(params[:user_id])
    @form_type = Form.find_by_id(params[:id])
    @form_name = @form_type.form_name
    @list_of_questions = @form_type.get_sorted_form_questions
    application = @user.get_most_recent_application
    if application
      @saved_form = application.content
      if @saved_form.has_key?(@form_name)
        @form_answer = get_answers_to_prefill_from(@saved_form[@form_name], @form_name)
      end
    end
  end

  def update
    @user = User.find_by_id(params[:user_id])
    @form_type = Form.find_by_id(params[:id])
    @form_name = @form_type.form_name
    @form_content = get_form_content
    @application = @user.get_most_recent_application
    if params[:commit] == "Save and Return"
      update_application(false)
      flash[:notice] = "#{@form_name} successfully saved."
      redirect_to user_path(@user)
    elsif params[:commit] == 'Submit'
      submit
    end
  end

  #filter that check if the form is filled correctly
  def form_completed?
  	!(@form_content[@form_name].has_value?("") || @form_content[@form_name].has_value?(nil))
  end
  
  # Form an array of answers using the params
  def get_answers
    answers_list = []
    num_questions = @form_type.number_of_questions
    (0..(num_questions - 1)).each do |index|
      answers_list[index] = params[:form_answer].has_key?(index.to_s) ? params[:form_answer][index.to_s] : nil
    end
    answers_list
  end

  def get_form_content
    @questions_list = @form_type.get_sorted_form_questions
    form_content = {
      @form_name => Hash.new
    }
    answer_list = get_answers
    index = 0
    @questions_list.each do |question|
      if question.question_type == "statement"
        form_content[@form_name][question.question] = "No Answer Required For Statement Questions"
      else
        form_content[@form_name][question.question] = answer_list[index]
      end
      index += 1
    end
    form_content
  end

  def update_application(completed)
    @form_content[@form_name][:completed] = completed
    @application.add_content(@form_content)
  end

  def submit
    if form_completed?
      update_application(true)
      flash[:notice] = "Submitted #{@form_name}"
      redirect_to user_path(@user)
    else
      flash[:alert] = "There are missing fields in the form"
      @list_of_questions = @form_type.get_sorted_form_questions
      @form_answer = params[:form_answer]
      render :show
    end
  end

  private

  def validate_accessible_form
    user_app_type = User.find_by_id(params[:user_id]).get_most_recent_application.application_type
    form_type = Form.find_by_id(params[:id])
    unless user_app_type.forms.include? form_type
      flash[:alert] = "Form cannot be found."
      redirect_to user_path
    end
  end

end
