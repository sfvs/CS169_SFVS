class Admin::FormsController < Admin::AdminController
  before_filter :require_admin

  def index
    @forms = Form.paginate(:page => params[:page], :per_page => 10)
  end
end