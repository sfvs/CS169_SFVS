require 'spec_helper'

describe UsersController do
  login(:user, :email => "i_am_a_coconut@mail.com")

  describe "show action" do
    render_views
    it "should show the user profile" do
      get :show, :id => @user.id
      response.should be_success
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
      @mock_app.completed = true
      @mock_app.save
      User.stub(:get_most_recent_application).and_return(@mock_app)
      get :show, :id => @user.id
      assigns(:status).should_not match /incomplete/i
      response.should be_success
    end
  end
end
