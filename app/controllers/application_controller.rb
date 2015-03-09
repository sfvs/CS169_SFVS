class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :user_signed_in?
end
