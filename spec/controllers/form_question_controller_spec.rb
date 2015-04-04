require 'spec_helper'

describe FormQuestionController do
  login(:user, :email => "i_am_a_coconut@mail.com")
  describe "valid form question" do
  	make_test_form_questions

  	it "opens a new form" do 
  	  get :show, :id => @user.id, :type => @test_form
  	  expect(response).to render_template(:show)
  	end

    it "should redirect to profile when the form is correctly completed" do
      get :show, :id => @user.id, :type => @test_form, :submit => true
      response.should redirect_to user_path(@user)
    end

    it "should not redirect if the form is not correctly completed" do
      FormQuestionController.stub(:form_completed?) {false}
      get :show, :id => @user.id, :type => @test_form, :submit => true
      response.should_not_receive(:redirect_to)
    end

    it "should return false if the form is not completed" do 
      #test not writtien yet
    end

    it "should update db if click save" do
      #test not written yet
    end

    it "should redirect if click save" do
      get :show, :id => @user.id, :type => @test_form, :save => true
      response.should redirect_to user_path(@user)
    end
  end
end
