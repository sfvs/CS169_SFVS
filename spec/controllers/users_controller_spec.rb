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
      reply = 1
      application_type = make_forms_for_app_type "vendor"
      ApplicationType.stub(:find_by_id).with(reply).and_return(application_type)
      User.stub(:get_most_recent_inprogress_application).with(@user).and_return(nil)
      get :show, :id => @user.id, :questionnaire_response => reply
      response.should be_success
    end

  end

  describe "questionnaire answer parser" do
    before (:each) do
      @reply = 1
      @type = make_forms_for_app_type "vendor"
    end

    it "should correctly make an application based on the questionnaire response" do
      ApplicationType.stub(:find_by_id).with(@reply).and_return(@type)
      get :show, :id => @user.id, :questionnaire_response => @reply

      application = @user.applications[0]
      expect(application.user_id).to be == @user.id
      expect(application.application_type).to be == @type
    end

    it "should correctly delete the most recent application and create a new application" do
      Application.latest_year = 2015
      mock_app = FactoryGirl.create(:application)
      mock_app.user = @user
      mock_app.year = Application.latest_year
      mock_app.application_type = @type
      mock_app.completed = false
      mock_app.save

      ApplicationType.stub(:find_by_id).with(@reply).and_return(@type)
      User.stub(:get_most_recent_application).with(@user).and_return(mock_app)
      get :show, :id => @user.id, :questionnaire_response => @reply

      Application.find_by_id(mock_app).should == nil
    end
  end

  describe "completing an application" do
    make_a_vendor_application_for_user

    it "should mark an incomplete application as complete when submit is pressed" do
      User.stub(:get_most_recent_application).and_return(@mock_app)
      post :submit_application, :id => @user.id
      response.should redirect_to user_path
      @mock_app.reload
      expect(@mock_app.completed).to be_true
    end

    it "should show the completed user profile" do
      @mock_app.completed = be_true
      @mock_app.save
      get :show, :id => @user.id
      response.should be_success
    end

  end
end
