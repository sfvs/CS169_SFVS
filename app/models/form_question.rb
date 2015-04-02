class FormQuestion < ActiveRecord::Base
  attr_accessible :question, :answers, :app_type, :question_type, :order

  def get_form_question_types
  	[:checkbox, :textbox, :radio_button, :statement]
  end

  def get_form_type
  	[:restaurant_concessionaire => 1, :advertising_form => 2 , :health_form => 3]
  end 
end
