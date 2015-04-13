require 'spec_helper'

describe FormQuestionController do
  login(:user, :email => "i_am_a_coconut@mail.com")
  describe "valid form question" do
  	make_test_form_questions
    before :each do 
      Form.stub(:where).and_return([@test_form])

      @type = make_forms_for_app_type "vendor"
      Application.latest_year = 2015
      mock_app = FactoryGirl.create(:application)
      mock_app.user = @user
      mock_app.year = Application.latest_year
      mock_app.application_type = @type
      mock_app.completed = false
      mock_app.save
      @form = make_form_with_questions
      @form_answer = {"0" => "", "1" => "Yes", "2" => "No"}
    end

  	it "opens a new form" do 
  	  get :show, :id => @user.id, :type => @test_form
  	  expect(response).to render_template(:show)
  	end

    it "should redirect to profile when the form is correctly completed" do
      FormQuestionController.any_instance.stub(:form_completed?).and_return(true)
      FormQuestionController.any_instance.stub(:get_answers).and_return({})
      FormQuestionController.any_instance.stub(:get_form_content).and_return({})
      FormQuestionController.any_instance.stub(:update_application)
      post :save_progress, :id => @user.id, :type => @test_form, :commit => "Submit"
      response.should redirect_to user_path(@user)
    end

    it "should not redirect if the form is not correctly completed" do
      FormQuestionController.any_instance.stub(:form_completed?).and_return(false)
      get :show, :id => @user.id, :type => @test_form
      response.should_not_receive(:redirect_to)
    end

    it "should redirect if click Save and Return" do
      FormQuestionController.any_instance.stub(:get_answers).and_return({})
      FormQuestionController.any_instance.stub(:get_form_content).and_return({})
      FormQuestionController.any_instance.stub(:update_application)
      post :save_progress, :id => @user.id, :type => @test_form, :commit => "Save and Return"
      response.should redirect_to user_path(@user)
    end

    it "should not update the db if the form is not complete" do 
      post :save_progress, :id => @user.id, :type => @form.form_name, :commit => "Submit", :form_answer => @form_answer
      @user.reload
      application = @user.get_most_recent_application
      application.content.should == {}
    end

    it "should update db if click save" do
      #test not written yet
    end
    
  end
end
