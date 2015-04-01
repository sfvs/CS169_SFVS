class FormQuestion < ActiveRecord::Base
  attr_accessible :question, :app_type, :question_type, :order
  belongs_to :form

  def get_form_question_types
  	[:checkbox, :textbox, :radio_button]
  end
end
