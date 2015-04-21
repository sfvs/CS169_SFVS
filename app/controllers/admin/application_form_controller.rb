class Admin::ApplicationFormController < Admin::AdminController

  include ApplicationHelper
  include FormQuestionHelper

  before_filter :require_admin
  def show
    # The view should render only the form questions and form answers
    # They should not be able to modify at this page
    # Note might need to write a method to get the form_contents
    @disable = true
    @application = Application.find(params[:id])
    if @application.content.has_key?(params[:form_type])
      @form_answer = get_answers_to_prefill_from(@application.content[params[:form_type]], params[:form_type])
    end
    form = @application.get_form(params[:form_type])
    @list_of_questions = form.form_questions
    @form_name = form.form_name
  end

  def edit
    @disable = false
    @user = User.find_by_id(params[:user_id])
    @application = Application.find(params[:id])
    if @application.content.has_key?(params[:form_type])
      @form_answer = get_answers_to_prefill_from(@application.content[params[:form_type]], params[:form_type])
    end
    @form = @application.get_form(params[:form_type])
    @list_of_questions = @form.form_questions
    @form_name = @form.form_name
  end

  def update
    @user = User.find_by_id(params[:user_id])
    @application = Application.find(params[:id])
    if @application.content.has_key?(params[:form_type])
      @form_answer = get_answers_to_prefill_from(@application.content[params[:form_type]], params[:form_type])
    end
    @form = @application.get_form(params[:form_type])
    @form_content = get_form_content(@form, params[:form_answer])
    if params[:commit] == 'Submit'
      submit
    end
  end

  def form_completed?
    @form_name = params[:form_type]
    !(@form_content[@form_name].has_value?("") || @form_content[@form_name].has_value?(nil))
  end

  def submit
    if form_completed?
      update_application(true)
      flash[:notice] = "Submitted #{@form_name}"
      redirect_to admin_user_application_path(:user_id => params[:user_id], :id => param[:id])
    else
      flash[:alert] = "There are missing fields in the form"
      @list_of_questions = @form.get_sorted_form_questions
      @form_answer = params[:form_answer]
      render :show
    end
  end

end