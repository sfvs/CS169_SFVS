require 'spec_helper'

describe FormQuestion do
  make_test_form_questions
  
  describe "FormQuestion functions" do
    it "should give me all the form types" do
      FormQuestion.get_form_question_types.should be_true
    end
      
    it "should give me all the form types" do
      a = FormQuestion.create(:question => 'hello"world', :answers => 'Hi""', :question_type => :checkbox)
      expect(a.question).to match 'helloworld'
      expect(a.answers).to match 'Hi'
    end
  end
end
