class Admin::FormQuestionsController < Admin::AdminController
  before_filter :require_admin

  def index
    @form = Form.find(params[:form_id])
    gon.form_id = params[:form_id]
    @form_questions = @form.form_questions.sort_by {|question| question.order}
  end

  def new
    #default: render 'new' template
  end

  def create
    # might need to create the correct format of arguments to be passed
    # Need to format the answers correctly
    params[:form_question][:answers] = get_answers_from_param
    logger.debug "The parameters passed are #{params[:form_question]}"
    redirect_to admin_form_form_questions_path
  end

  def destroy
    @form_question = FormQuestion.find(params[:id])
    @form_question.destroy
    flash[:notice] = "Question deleted."
    redirect_to admin_form_form_questions_path(Form.find(params[:form_id]))
  end

  def edit

  end

  def sort
    params[:order].each do |key, value|
      FormQuestion.find(value[:id]).update_attributes({:order => value[:position].to_i})
    end
    render :nothing => true
  end

  def get_answers_from_param
    answers = []
    params[:q_answer][:answers].each do |key, value|
      answers << value
    end
    answers
  end
end