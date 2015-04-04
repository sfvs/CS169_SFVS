class Admin::FormsController < Admin::AdminController
  before_filter :require_admin

  def index
    @forms = Form.find(:all)
  end
end