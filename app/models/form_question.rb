class FormQuestion < ActiveRecord::Base
  attr_accessible :question, :answers, :form_type, :question_type, :order

  def get_form_question_types
  	[:checkbox, :textbox, :radio_button, :statement, :message]
  end

  def self.get_questions_for_form(form_type)
  	self.where(form_type: form_type).order(order: :asc)
  end
end
