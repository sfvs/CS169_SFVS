require 'spec_helper'

describe Admin::ApplicationFormController do
  login :admin
  before :each do
    @user = make_a_member :user, :email => "rspecftw@hostname.com"
  end

  make_a_vendor_application_for_user

  before :each do
    @user.reload
    @application = @user.applications[0]
    @form_name = @application.application_type.forms[0].form_name
  end

  describe "show action" do

    

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
  
  describe "form edit page" do
    it "returns http success" do
      get 'edit', :user_id => @user.id, :id => @application.id, :form_type => @form_name
      response.should be_success
    end

    it "should reder the page if form is not completed" do
      put 'update', :form_type => @form_name, :id => @application.id, :user_id => @user.id, :form_answer => {}
      expect(response).to render_template(:edit)
    end

    it "should redirect to form content page when pressed Submit Form" do
      attribute = {:form_answer => {"0" => "please", "1" => "be", "2" => "working"}}
      put 'update', :form_type => @form_name, :id => @application.id, :user_id => @user.id, :form_answer => attribute[:form_answer]
      response.should redirect_to '/admin/users/' + @user.id.to_s + '/applications/' + @application.id.to_s
    end

    it "should update the form question" do 
      attribute = {:form_answer => {"0" => "please", "1" => "be", "2" => "working"}}
      put 'update', :form_type => @form_name, :id => @application.id, :user_id => @user.id, :form_answer => attribute[:form_answer]
      updated_form_q = Application.where(:id => @application.id).first
      updated_form_q.content[@form_name]["General Question 1"].should eq "please"
      updated_form_q.content[@form_name]["General Question 2"].should eq "be"
      updated_form_q.content[@form_name]["General Question 3"].should eq "working"
    end
  end
end