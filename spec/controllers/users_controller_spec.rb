require 'spec_helper'

describe UsersController do
  login(:user, :email => "i_am_a_coconut@mail.com")

  describe "show action" do
    render_views
    it "should show the user profile" do
      get :show, :id => @user.id
      response.should be_success
    end

    it "should show the user profile with the questionnaire response" do
      get :show, :id => @user.id, :questionnaire_response => "1"
      response.should be_success
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
