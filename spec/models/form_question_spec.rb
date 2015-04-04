require 'spec_helper'

describe FormQuestion do
  describe "form question functions" do
    it "tells me list of form question types" do
      FormQuestion.get_form_question_types.should be_true
    end
  end
end
