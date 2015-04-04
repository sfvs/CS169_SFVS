class Form < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :form_name
  has_many :form_questions
  has_and_belongs_to_many :application_types

  def self.number_of_questions(id)
    Form.find(id).form_questions.count
  end

end
