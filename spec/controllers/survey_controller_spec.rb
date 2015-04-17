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

    it "should still work with bad ans" do
      bad_ans = 200
      get :questionnaire, :id => @user.id, :ans => bad_ans.to_s
      response.should be_success
    end
  end

end
