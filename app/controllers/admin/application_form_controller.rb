class Admin::ApplicationFormController < Admin::AdminController
  before_filter :require_admin

  def show
    # The view should render only the form questions and form answers
    # They should not be able to modify at this page
  end
end