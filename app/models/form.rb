class Form < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :form_name
  has_many :form_questions
  has_and_belongs_to_many :application_types

  def number_of_questions
    self.form_questions.count
  end

  def get_sorted_form_questions
  	self.form_questions.sort_by {|e| e.order}
  end

  def get_list_of_questions
    questions_list = []
    form_questions = self.get_sorted_form_questions.each do |question|
      questions_list << question.question
    end    
    questions_list
  end

  def update_form_questions_order
    form_questions = self.get_sorted_form_questions
    order = 0
    form_questions.each do |question|
      question.update_attribute(:order,order)
      order += 1
    end
  end

end
