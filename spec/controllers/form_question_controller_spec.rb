require 'spec_helper'

describe FormQuestionController do
  login(:user, :email => "i_am_a_coconut@mail.com")
  describe "valid form question" do
  	make_test_form_questions    
    make_a_vendor_application_for_user

    before :each do
      @form = @mock_app.application_type.forms[0]
      @form_answer = {"0" => "", "1" => "Yes", "2" => "No"}
    end

  	it "opens a new form" do 
      form = @type.forms[0]
      Form.stub(:find_by_id).and_return(form)
      Application.stub(:get_most_recent_application).and_return(@mock_app)

  	  get :show, :id => @user.id, :form_id => form.id
  	  expect(response).to render_template(:show)
  	end

    it "should redirect to profile when the form is correctly completed" do
      Form.stub(:where).and_return([@test_form])
      FormQuestionController.any_instance.stub(:form_completed?).and_return(true)
      FormQuestionController.any_instance.stub(:get_answers).and_return({})
      FormQuestionController.any_instance.stub(:get_form_content).and_return({})
      FormQuestionController.any_instance.stub(:update_application)
      post :save_progress, :id => @user.id, :form_id => @test_form, :commit => "Submit"
      response.should redirect_to user_path(@user)
    end

    it "should not redirect if the form is not correctly completed" do
      Form.stub(:where).and_return([@test_form])
      FormQuestionController.any_instance.stub(:form_completed?).and_return(false)
      get :show, :id => @user.id, :form_id => @test_form
      response.should_not_receive(:redirect_to)
    end

    it "should redirect if click Save and Return" do
      Form.stub(:where).and_return([@test_form])
      FormQuestionController.any_instance.stub(:get_answers).and_return({})
      FormQuestionController.any_instance.stub(:get_form_content).and_return({})
      FormQuestionController.any_instance.stub(:update_application)
      post :save_progress, :id => @user.id, :form_id => @test_form, :commit => "Save and Return"
      response.should redirect_to user_path(@user)
    end

    it "should not update the db if the form is not complete" do 
      post :save_progress, :id => @user.id, :form_id => @form, :commit => "Submit", :form_answer => @form_answer
      @user.reload
      application = @user.get_most_recent_application
      application.content.should == {}
    end

    it "should update db if click save" do
      post :save_progress, :id => @user.id, :form_id => @form, :commit => "Save and Return", :form_answer => @form_answer
      @user.reload
      application = @user.get_most_recent_application
      application.content.should == {@form.form_name => {"General Question 1" => "", "General Question 2" => "Yes", "General Question 3" => "No", "completed" => false}}
    end

    it "should update the db if the form is complete" do
      @completed_form_answer = {"0" => "Yes", "1" => "Yes", "2" => "No"}
      post :save_progress, :id => @user.id, :form_id => @form, :commit => "Submit", :form_answer => @completed_form_answer
      @user.reload
      application = @user.get_most_recent_application
      application.content.should == {@form.form_name => {"General Question 1" => "Yes", "General Question 2" => "Yes", "General Question 3" => "No", "completed" => true}}
    end

    it "should prefill the form fields if there is a saved form" do
      application = @user.get_most_recent_application
      application.content = {@form.form_name => {"General Question 1" => "Yes", "General Question 2" => "Yes", "General Question 3" => "No", "completed" => true}}
      application.save
      get :show, :id => @user.id, :form_id => @form
      assigns(:form_answer).should == {"0"=>"Yes", "1"=>"Yes", "2"=>"No"}
    end
    
    describe "invalid path" do
      it "should redirect an invalid path back to the profile page" do
        invalid_form = 2123
        get :show, :id => @user.id, :form_id => invalid_form
        response.should redirect_to user_path
      end
    end

  end
end
