class Admin::ApplicationFormController < Admin::AdminController

  include ApplicationHelper
  include FormQuestionHelper

  before_filter :require_admin
  def show
    # The view should render only the form questions and form answers
    # They should not be able to modify at this page
    # Note might need to write a method to get the form_contents
    @disable = true
    @user, @application, @form, @list_of_questions, @form_name, @form_answer = prepare_display
  end

  def edit
    @disable = false
    @user, @application, @form, @list_of_questions, @form_name, @form_answer = prepare_display
  end

  def update
    @user = User.find_by_id(params[:user_id])
    @form_name = params[:form_type]
    @form = Form.where(form_name: @form_name).first
    @form_content = get_form_content(@form, params[:form_answer])
    logger.debug "form_answer: #{params[:form_answer]}"
    logger.debug "form_content: #{@form_content}"
    @application = @user.get_most_recent_application
    submit
  end

  def form_completed?
    @form_name = params[:form_type]
    !(@form_content[@form_name].has_value?("") || @form_content[@form_name].has_value?(nil))
  end

  def update_application(completed)
    @form_content[@form_name][:completed] = completed
    @application.add_content(@form_content)
  end

  def submit
    if form_completed?
      update_application(true)
      flash[:notice] = "Submitted #{@form_name}"
      redirect_to admin_user_application_path(:user_id => params[:user_id], :id => params[:id])
    else
      flash[:alert] = "There are missing fields in the form"
      @list_of_questions = @form.get_sorted_form_questions
      @form_answer = params[:form_answer]
      render :edit
    end
  end

  def prepare_display
    user = User.find_by_id(params[:user_id])
    application = Application.find(params[:id])
    if application.content.has_key?(params[:form_type])
      form_answer = get_answers_to_prefill_from(application.content[params[:form_type]], params[:form_type])
    end
    form = application.get_form(params[:form_type])
    list_of_questions = form.form_questions.sort_by {|question| question.order}
    form_name = form.form_name
    return user, application, form, list_of_questions, form_name, form_answer
  end
end