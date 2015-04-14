require 'spec_helper'

describe Admin::ApplicationFormController do
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

    it "should assign @application to the corresponding application" do
      get 'show', :user_id => @user.id, :id => @application.id, :form_type => @form_name
      response.should be_success
      assigns(:application).should == @application
    end

    it "should assign @form_answer with answers to prefill in the view" do
      @application.add_content({@form_name => {"question 1" => "answer 1", "completed" => true}})
      @application.reload
      get 'show', :user_id => @user.id, :id => @application.id, :form_type => @form_name
      response.should be_success
      assigns(:form_answer).should == {"0" => "answer 1"}
    end

    it "should assign @list_of_questions with questions from the form" do
      get 'show', :user_id => @user.id, :id => @application.id, :form_type => @form_name
      response.should be_success
      assigns(:list_of_questions).should == @application.application_type.forms[0].form_questions
    end
  end
end