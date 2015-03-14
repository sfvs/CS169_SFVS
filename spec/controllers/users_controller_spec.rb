require 'spec_helper'

describe UsersController do
  login(:user, :email => "i_am_a_coconut@mail.com")
  describe "valid questionnaire" do
    make_question_answer_tree

    it "opens a new questionnaire" do
      get :questionnaire, :id => @user.id
    end

    it "opens the questionnaire with current question not as last question" do
      get :questionnaire, :id => @user.id, :ans => "#{@a1a.id}"
    end

    it "opens the questionnaire with current question being last question" do
      get :questionnaire, :id => @user.id, :ans => "#{@a2.id}"
    end

    it "should not work with bad id" do
      get :questionnaire, :id => 15, :ans => "3"
      response.should_not be_success
    end
  end

  describe "show action" do
    it "should show the questionnaire page" do
      get :show, :id => @user.id, :questionnaire_response => "1"
    end
  end

  describe "questionnaire answer parser" do
    it "should correctly parse questionnaire response" do
      # up to 6 so that it explores the else branch
      for i in 2..6
        get :show, :id => @user.id, :questionnaire_response => "#{i}"
        expect(response).to be_success
      end
    end
  end
end
