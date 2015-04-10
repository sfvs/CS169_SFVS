class Admin::FormsController < Admin::AdminController
  before_filter :require_admin

  def index
    @forms = Form.page(params[:page]).per(10)
  end
end