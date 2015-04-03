class FormQuestion < ActiveRecord::Base
  attr_accessible :question, :answers, :form_type, :question_type, :order
  belongs_to :form

  def get_form_question_types
  	[:checkbox, :textbox, :radio_button, :statement]
  end

  def self.get_questions_for_form(form_id)
    self.where(:form_id => form_id).order(order: :desc)
  end
end
