class ApplicationType < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :app_type, :description
  has_and_belongs_to_many :forms
end
