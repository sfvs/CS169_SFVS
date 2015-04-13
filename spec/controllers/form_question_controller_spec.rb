require 'spec_helper'

describe FormQuestionController do
  login(:user, :email => "i_am_a_coconut@mail.com")
  describe "valid form question" do
  	make_test_form_questions
    before :each do 
      Form.stub(:where).and_return([@test_form])
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

    it "should return false if the form is not completed" do 
      #test not writtien yet
    end

    it "should update db if click save" do
      #test not written yet
    end
    
  end
end
