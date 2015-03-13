require 'spec_helper'

describe UsersController do
  login(:user, :email => "i_am_a_coconut@mail.com")
  describe "user validation" do
    it "works with valid logged in user" do
      get :questionnaire, :id => @user.id, :ans => "1"
      #response.should be_success
    end

    it "should not work with bad id" do
      get :questionnaire, :id => 15, :ans => "3"
      response.should_not be_success
    end
  end

  describe "show action" do
    it "should show the questionnaire page" do
      get :show, :id => @user.id, :questionnaire_response => "3"
    end
  end

  describe "questionnaire answer parser" do
    it "should correctly parse questionnaire response" do
      # up to 10 so that it explores the else branch
      for i in 3..10
        get :show, :id => @user.id, :questionnaire_response => "#{i}"
        expect(response).to be_success
      end
    end
  end
end
