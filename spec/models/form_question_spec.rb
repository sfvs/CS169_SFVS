require 'spec_helper'

describe FormQuestion do

  make_test_form_questions
  describe "FormQuestion functions" do
  	it "should get me all the questions for my form" do
      Form.stub(:where).and_return([@test_form])
  	  FormQuestion.get_questions_for_form(@test_form).length.should == 4
  	end

  	it "should return questions in order" do
      Form.stub(:where).and_return([@test_form])
  	  q = FormQuestion.get_questions_for_form(@test_form)
  	  (0..2).each do |ct|
  	    q[ct].order.should < q[ct+1].order
  	  end
  	end

  	it "should give me all the form types" do
  	  FormQuestion.get_form_question_types.should == [:checkbox, :textbox, :radio_button, :statement, :message]
  	end
  end
end
