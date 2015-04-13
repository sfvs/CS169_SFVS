class Admin::ApplicationFormController < Admin::AdminController
  before_filter :require_admin

  def show
    # The view should render only the form questions and form answers
    # They should not be able to modify at this page
    # Note might need to write a method to get the form_contents
    @application = Application.find(params[:id])
    if @application.content.has_key?(params[:form_type])
      @form_answer = get_answers_to_prefill_from(@application.content[params[:form_type]])
    end
    @list_of_questions = FormQuestion.get_questions_for_form(params[:form_type])
  end

  def get_answers_to_prefill_from(content)
    number_of_questions = Form.where(form_name: params[:form_type])[0].number_of_questions
    form_answer = Hash.new
    cur_num_questions = 0
    content.each do |key, value|
      if cur_num_questions != number_of_questions && key != "completed"
        form_answer[cur_num_questions.to_s] = value
        cur_num_questions += 1
      end
    end
    form_answer
  end
end