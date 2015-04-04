class Form < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :form_name
  has_many :form_questions
  belongs_to :application

  def self.number_of_questions(id)
    Form.find(id).form_questions.count
  end
end
