class FormQuestion < ActiveRecord::Base
  attr_accessible :question, :answers, :form_type, :question_type, :order
  belongs_to :form

  def self.get_form_question_types
  	[:checkbox, :textbox, :radio_button, :statement, :message]
  end

  def self.get_questions_for_form(form_type)
  	Form.where(form_name: form_type)[0].form_questions.sort_by {|e| e.order}
  end

  def self.get_list_of_questions(form_type)
    questions_list = []
    form_questions = self.get_questions_for_form(form_type).each do |question|
      questions_list << question.question
    end    
    questions_list
  end

  def self.update_order(form_id)
    form_questions = self.get_questions_for_form(Form.find(form_id).form_name)
    order = 1
    form_questions.each do |question|
      question.update_attribute(:order,order)
      order += 1
    end
  end
end
