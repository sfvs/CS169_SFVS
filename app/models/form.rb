class Form < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :form_name
  has_many :form_questions
  belongs_to :application
end
