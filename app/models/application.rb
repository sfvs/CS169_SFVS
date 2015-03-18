class Application < ActiveRecord::Base
  attr_accessible :user, :year, :status, :content
end
