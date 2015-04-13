class Admin::ApplicationsController < Admin::AdminController
	before_filter :require_admin

  def show
    # Options:
    # 1. Get user with user_id then get the corresponding application
    # 2. Get the application using application id (:id)
  end
end