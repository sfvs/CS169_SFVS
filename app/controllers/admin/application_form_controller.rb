class Admin::ApplicationFormController < Admin::AdminController

  include ApplicationHelper
  include FormQuestionHelper

  before_filter :require_admin

  def show
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
    @form = Form.where("form_name=?", @form_name).first
    @form_content = get_form_content(@form, params[:form_answer])
    @application = @user.get_most_recent_application
    submit
  end

  def submit
    if form_completed?(@form_content, @form_name)
      @application.update_application(true, @form_content, @form_name)
      flash[:notice] = "Updated #{@form_name}"
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
    return user, application, form, list_of_questions, form.form_name, form_answer
  end
end