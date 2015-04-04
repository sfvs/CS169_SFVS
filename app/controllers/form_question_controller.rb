class FormQuestionController < ApplicationController

  def show
    @form_type = params[:type]
    @list_of_questions = FormQuestion.get_questions_for_form(@form_type)
  	if (params[:submit]) 
      if form_completed?
        flash[:notice] = "#{@form_type} successfully submitted."
      	redirect_to user_path()
      else
      	@error = "Please complete the form before submitting."
      end
    elsif (params[:save])
      save_progress
      flash[:notice] = "#{@form_type} successfully saved."
      redirect_to user_path()
    end
  end

  private
  #filter that check if the form is filled correctly
  def form_completed?
  	true
  end
  #update db with progress
  def save_progress

  end

end
