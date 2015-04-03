class Application < ActiveRecord::Base
  attr_accessible :user, :year, :app_type, :content, :completed
  belongs_to :user
  has_one :application_type

end
