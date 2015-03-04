class Application < ActiveRecord::Base
  # attr_accessible :title, :body
  has_one :health_form
end
