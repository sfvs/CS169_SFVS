require 'spec_helper'

describe FormQuestion do
  make_test_form_questions
  
  describe "FormQuestion functions" do
    it "should give me all the form types" do
      FormQuestion.get_form_question_types.should == [:checkbox, :textbox, :radio_button, :statement, :message]
    end
  
  end
end
