require 'spec_helper'

describe Form do
  describe "form functions" do

    it "tells me the number of questions for in a form" do
      num_of_questions = 5
      form = make_a_form
      add_questions_to_form form, num_of_questions
      form.number_of_questions.should == num_of_questions
    end

    it "should order the form questions correctly" do
      num_of_questions = 4
      shift_question_order = 2
      form = make_a_form
      add_questions_to_form(form,num_of_questions,shift_question_order)
      Form.stub(:get_questions_for_form).and_return(form.form_questions)
      
      form.update_form_questions_order
      form.reload
      order = 0
      form.form_questions.each do |question|
        question.order.should == order
        order += 1
      end
    end
  end

  describe "working with some form questions" do
    make_test_form_questions

    it "should get me all the questions for my form" do
      @test_form.get_sorted_form_questions.length.should == 4
    end

    it "should return questions in order" do
      q = @test_form.get_sorted_form_questions
      (0..2).each do |ct|
        q[ct].order.should < q[ct+1].order
      end
    end

  end
end
