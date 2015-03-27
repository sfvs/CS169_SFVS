class Application < ActiveRecord::Base
  attr_accessible :user, :year, :type, :content, :completed

  def get_application_types
  	[:vendor, :donor, :restaurant_concessionaire, :other]
  end
end
