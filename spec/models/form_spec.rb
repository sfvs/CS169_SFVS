require 'spec_helper'

describe Form do
  describe "form functions" do
    it "tells me the number of questions for in a form" do
      num_of_questions = 3
      form = make_form_with_questions num_of_questions
      form.number_of_questions.should == form.form_questions.count
    end
  end
end
