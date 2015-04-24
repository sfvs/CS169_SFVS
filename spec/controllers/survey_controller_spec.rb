require 'spec_helper'

describe SurveyController do
  login(:user, :email => "i_am_a_coconut@mail.com")
  make_question_answer_tree
  
  describe "valid questionnaire" do
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

  describe "questionnaire answer parser" do

    it "should correctly make an application based on the questionnaire response" do
      ApplicationType.stub(:find_by_id).with(@reply).and_return(@type_vendor)
      post :submit_questionnaire, {:id => @user.id, :results => @a2.results_to}

      application = @user.applications.first
      expect(application.user_id).to be == @user.id
      expect(application.application_type).to be == @type_vendor
    end
  end
end
