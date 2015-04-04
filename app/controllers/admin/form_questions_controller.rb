class Admin::FormQuestionsController < Admin::AdminController
  before_filter :require_admin

  def index
    @form = Form.find(params[:form_id])
    gon.form_id = params[:form_id]
    @form_questions = @form.form_questions.sort_by {|question| question.order}
    logger.debug "The form questions are #{@form_questions}"
  end

  def new
    #default: render 'new' template
  end

  def create
    # might need to create the correct format of arguments to be passed
    # Need to format the answers correctly
    @form = Form.find(params[:form_id])
    q_type = params[:form_question][:question_type]

    if q_type == "checkbox"
      params[:form_question][:answers] = get_answers_from_param(:check_answer)
    elsif q_type == "radio_button" 
      params[:form_question][:answers] = get_answers_from_param(:radio_answer)
    end
    params[:form_question][:order] = Form.number_of_questions(params[:form_id]) + 1

    @form.form_questions.create(params[:form_question])
    redirect_to admin_form_form_questions_path
  end

  def destroy
    @form_question = FormQuestion.find(params[:id])
    @form_question.destroy
    flash[:notice] = "Question deleted."
    redirect_to admin_form_form_questions_path(Form.find(params[:form_id]))
  end

  def edit
    # edit the form question
  end

  def sort
    params[:order].each do |key, value|
      FormQuestion.find(value[:id]).update_attributes({:order => value[:position].to_i})
    end
    render :nothing => true
  end

  def get_answers_from_param(option)
    answers = []
    params[option].each do |key, value|
      if value != ""
        answers << value
      end
    end
    logger.debug "The answers are #{answers}"
    return answers.to_s.gsub('"','')
  end
end