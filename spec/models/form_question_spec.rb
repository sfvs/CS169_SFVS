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

    it "should order the form questions correctly" do
      num_of_questions = 3
      shift_question_order = 2
      form = make_a_form
      add_questions_to_form(form, num_of_questions, shift_question_order)
      FormQuestion.stub(:get_questions_for_form).with(form.form_name).and_return(form.form_questions)
      FormQuestion.update_order(form.id)
      form.reload
      order = 0
      form.form_questions.each do |question|
        question.order.should == order
        order += 1
      end
    end
  end
end
