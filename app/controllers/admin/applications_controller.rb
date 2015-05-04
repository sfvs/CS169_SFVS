class Admin::ApplicationsController < Admin::AdminController
	before_filter :require_admin

  def show
    # Options:
    # 1. Get user with user_id then get the corresponding application
    # 2. Get the application using application id (:id)
    @user = User.find(params[:user_id])
    @application = Application.find(params[:id])
    @app_forms = @application.get_forms
    @completed_forms = @application.get_completed_forms
    @health_form_file = @application.file_attachments.find_by_file_type(:health_form)
    @advertisement_file = @application.file_attachments.find_by_file_type(:advertisement)
  end

  def approve
    @application = Application.find(params[:id])
    if @application.completed? && @application.payment.has_paid
      @application.update_attribute(:approved, params[:approve])
    else
      flash[:alert] = @application.completed? == false ? "Application needs to be completed before being approved." : "Payment was not made for this application."
    end
    redirect_to admin_user_path(params[:user_id])
  end
end