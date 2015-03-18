class FormQuestion < ActiveRecord::Base
  attr_accessible :question, :form_type, :question_type, :order
end
