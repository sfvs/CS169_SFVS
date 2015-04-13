class Admin::ApplicationFormController < Admin::AdminController
  before_filter :require_admin

  def show
    # The view should render only the form questions and form answers
    # They should not be able to modify at this page
    # Note might need to write a method to get the form_contents
    @application = Application.find(params[:id])
    if @application.content.has_key?(params[:form_type])
      @form_contents = @application.content[params[:form_type]]
    else
      @form_contents = FormQuestion.get_list_of_questions(params[:form_type])
    end
    logger.debug "Form contents: #{@form_contents}"
  end
end