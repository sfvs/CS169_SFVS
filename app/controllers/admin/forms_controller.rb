class Admin::FormsController < Admin::AdminController
  
  def show
    @form = Form.find(params[:id])
  end

  def edit
    @form = Form.find(params[:id])
  end
end