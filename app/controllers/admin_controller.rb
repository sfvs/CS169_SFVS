class AdminController < ApplicationController
  def index
  	@users = User.find(:all, :conditions => ["admin = ?", false])
  end
end