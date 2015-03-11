class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery
  before_filter :authenticate_user!
end