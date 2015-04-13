require 'spec_helper'

describe Form do
  describe "form functions" do
    it "tells me the number of questions for in a form" do
      num_of_questions = 5
      form = make_a_form
      add_questions_to_form form, num_of_questions
      form.number_of_questions.should == num_of_questions
    end
  end
end
