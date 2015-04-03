class Admin::FormQuestionsController < Admin::AdminController
  before_filter :require_admin

  def index
    @form = Form.find(params[:form_id])
    @form_questions = @form.form_questions.sort_by {|question| question.order}
  end

  def sort
    params[:order].each do |key, value|
      FormQuestion.find(value[:id]).update_attributes({:order => value[:position].to_i})
    end
    render :nothing => true
  end
end