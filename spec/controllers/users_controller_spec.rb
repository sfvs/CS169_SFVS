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
      Application.any_instance.stub(:all_forms_completed?).and_return(true)
      post :submit_application, :id => @user.id
      response.should redirect_to user_path
      @mock_app.reload
      expect(@mock_app.completed).to be_true
    end

    it "should not mark an application as complete when there are still incompleted forms" do
      User.stub(:get_most_recent_application).and_return(@mock_app)
      Application.any_instance.stub(:all_forms_completed?).and_return(false)
      post :submit_application, :id => @user.id
      response.should redirect_to user_path
      @mock_app.reload
      expect(@mock_app.completed).to be_false
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

	describe "making a payment" do
		make_a_vendor_application_for_user
		
		it "should allow us to make payment" do
			User.stub(:get_most_recent_application).and_return(@mock_app)
			@mock_app.completed = true
			@mock_app.save
			post :submit_payment, :id => @user.id
			expect(response.location.starts_with?("https://www.sandbox.paypal.com")).to be_true
		end
	end
end
