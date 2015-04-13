class Admin::ApplicationFormController < Admin::AdminController

  include ApplicationHelper

  before_filter :require_admin

  def show
    # The view should render only the form questions and form answers
    # They should not be able to modify at this page
    # Note might need to write a method to get the form_contents
    @application = Application.find(params[:id])
    if @application.content.has_key?(params[:form_type])
      @form_answer = get_answers_to_prefill_from(@application.content[params[:form_type]], params[:form_type])
    end
    @list_of_questions = FormQuestion.get_questions_for_form(params[:form_type])
  end
end