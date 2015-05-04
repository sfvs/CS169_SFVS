require 'spec_helper'

describe Admin::ApplicationsController do
  login :admin
  
  describe "show action" do

    before :each do
      @user = make_a_member :user, :email => "rspecftw@hostname.com"
    end

    make_a_vendor_application_for_user

    before :each do
      @user.reload
      @application = @user.applications[0]
      @form_name = @application.application_type.forms[0].form_name
    end
    
    it "should assign @user to the corresponding user" do
      get 'show', :user_id => @user.id, :id => @application.id
      response.should be_success
      assigns(:user).should == @user
    end

    it "should assign @app_forms to the forms that correspond to application" do
      get 'show', :user_id => @user.id, :id => @application.id
      response.should be_success
      assigns(:app_forms).should == @application.application_type.forms
    end

    it "should assign @completed_forms to the forms that are completed" do
      @application.add_content({@form_name => {"completed" => true}})
      @application.reload
      get 'show', :user_id => @user.id, :id => @application.id
      response.should be_success
      assigns(:completed_forms).should == {@form_name => true}
    end

    it "should not aprove if the application is complete but not paid" do
      @application.update_attribute(:completed, true)
      post 'approve', :user_id => @user.id, :id => @application.id, :approve => true
      @application.reload
      @application.approved.should == false
    end

    it "should aprove if the application is complete and paid" do
      @application.update_attribute(:completed, true)
      @application.update_attribute(:has_paid, true)
      post 'approve', :user_id => @user.id, :id => @application.id, :approve => true
      @application.reload
      @application.approved.should == true
    end

    it "should not aprove if the application is not complete" do
      @application.update_attribute(:completed, false)
      post 'approve', :user_id => @user.id, :id => @application.id, :approve => true
      @application.reload
      @application.approved.should == false
    end
  end
end