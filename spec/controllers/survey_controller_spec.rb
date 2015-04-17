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

    it "should correctly delete the most recent application and create a new application" do
      app_year = stub_app_year 2015
      mock_app = FactoryGirl.create(:application)
      mock_app.user = @user
      mock_app.year = app_year
      mock_app.application_type = @type_vendor
      mock_app.completed = false
      mock_app.save

      User.stub(:get_most_recent_application).with(@user).and_return(mock_app)
      post :submit_questionnaire, {:id => @user.id, :results => @a1b.results_to}

      Application.find_by_id(mock_app).should == nil
      @user.get_most_recent_application.should_not be_nil
    end
  end

  describe "yearly applications" do
    it "should be able to make a new application some new year in the future" do
      # ApplicationType.stub(:find_by_id).with(@reply).and_return(@type)
      old_year = stub_app_year 2015
      app1 = @user.applications.create :completed => true, :year => old_year
      app1.application_type = @type_donor
      app1.save      

      new_year = stub_app_year 2018
      results = @a1b.results_to
      ApplicationType.stub(:find_by_id).with(results).and_return(@type_vendor)
      
      post :submit_questionnaire, {:id => @user.id, :results => results}
      @user.applications.length.should be == 2
    end
  end

end
