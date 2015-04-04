class Application < ActiveRecord::Base
  attr_accessible :year, :content, :completed
  belongs_to :user
  belongs_to :application_type

end
