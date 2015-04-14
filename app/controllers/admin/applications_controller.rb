class Admin::ApplicationsController < Admin::AdminController
	before_filter :require_admin

  def show
    # Options:
    # 1. Get user with user_id then get the corresponding application
    # 2. Get the application using application id (:id)
    @user = User.find(params[:user_id])
    @application = Application.find(params[:id])
    @app_forms = @application.get_forms
    @completed_forms = get_completed_forms(@application.content)
  end

  def get_completed_forms(content)
    # Hash, key name of form and value (true, false) depending on completed
    completed_forms = Hash.new
    content.each do |key, value|
      completed_forms[key] = value["completed"] == true ? true : false
    end
    completed_forms
  end
end