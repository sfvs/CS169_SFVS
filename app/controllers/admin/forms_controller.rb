class Admin::FormsController < Admin::AdminController
  before_filter :require_admin

  def index
    @forms = Form.find(:all)
  end

  def show
    @form = Form.find(params[:id])
    @form_questions = @form.form_questions
  end

  def edit
    @form = Form.find(params[:id])
    @form_questions = @form.form_questions
  end

  def create

  end

  def destroy
    @form = Form.find(params[:id])
    @form.destroy
    flash[:notice] = "#{@form.form_name} has beed removed."
    redirect_to admin_forms_path
  end
end