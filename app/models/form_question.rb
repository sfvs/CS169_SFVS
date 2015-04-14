class FormQuestion < ActiveRecord::Base
  attr_accessible :question, :answers, :form_type, :question_type, :order
  belongs_to :form

  def self.get_form_question_types
  	[:checkbox, :textbox, :radio_button, :statement, :message]
  end
end
