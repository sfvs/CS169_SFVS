class Form < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :form_questions
  belongs_to :application
end
