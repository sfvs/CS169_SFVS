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
      for i in 1..5
        get :show, :id => @user.id, :questionnaire_response => "#{i}"
        expect(response).to be_success
      end
    end

    it "should correctly make an application based on the questionnaire response" do
      get :show, :id => @user.id, :questionnaire_response => "1"
      application = @user.applications[0]
      expect(application.user_id).to be == @user.id
      expect(application.app_type).to be == "vendor"
    end

  end
end
