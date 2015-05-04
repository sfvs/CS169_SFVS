class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery
  force_ssl
  
  before_filter :authenticate_user!
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # need to refactor this, but home_controller cannot do multiple skips??
  def validate_user_authorization
    user = User.find_by_id(params[:id])
    require_valid_user user
  end
  
  def require_valid_user user
    authorize user, :is_profile_owner?
    authorize user, :is_regular_user?
  end

  def require_admin
    authorize current_user, :is_admin?
  end

  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  def not_found
    redirect_to root_path
  end

end
