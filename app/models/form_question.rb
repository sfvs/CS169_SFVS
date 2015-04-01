class FormQuestion < ActiveRecord::Base
  attr_accessible :question, :answers, :app_type, :question_type, :order

  def get_form_question_types
  	[:checkbox, :textbox, :radio_button, :statement]
  end
end
