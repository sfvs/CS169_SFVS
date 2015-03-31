class FormQuestion < ActiveRecord::Base
  attr_accessible :question, :type, :question_type, :order

  def get_form_question_types
  	[:checkbox, :textbox, :radio_button]
  end
end
