require 'spec_helper'

describe SurveyController do

  login(:user, :email => "i_am_a_coconut@mail.com")
  describe "valid questionnaire" do
    make_question_answer_tree

    it "opens a new questionnaire" do
      get :questionnaire, :id => @user.id
      response.should be_success
    end

    it "opens the questionnaire with current question not as last question" do
      get :questionnaire, :id => @user.id, :ans => "#{@a1a.id}"
      response.should be_success
    end

    it "opens the questionnaire with current question being last question" do
      get :questionnaire, :id => @user.id, :ans => "#{@a2.id}"
      response.should be_success
    end

    it "should not work with bad id" do
      get :questionnaire, :id => 15, :ans => "3"
      response.should_not be_success
    end
  end

end
