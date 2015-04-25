require 'spec_helper'

describe Admin::FormQuestionsController do
  render_views
  login :admin
  
  before :each do
    @form = make_a_form_with_questions
  end

  # Need to refactor this rspec test
  describe "form questions index page" do
    it "should assign @form_questions" do
      get 'index', :form_id => @form.id
      response.should be_success
      assigns(:form_questions).should == @form.form_questions
    end
  end

  describe "form content edit page" do
    it "returns http success" do
      get 'edit', :form_id => @form.id, :id => @form.form_questions[0].id
      response.should be_success
    end

    it "should redirect to form content page when pressed Cancel" do
      put 'update', :form_id => @form.id, :id => @form.form_questions[0].id, :commit => 'Cancel'
      response.should redirect_to '/admin/forms/' + @form.id.to_s + '/form_questions'
    end

    it "should redirect to form content page when pressed Update Form Question" do
      put 'update', :form_id => @form.id, :id => @form.form_questions[0].id, :form_question => {}
      response.should redirect_to '/admin/forms/' + @form.id.to_s + '/form_questions'
    end

    it "should update the form question" do 
      attribute = {
        :form_question => {:question => "RSpec test question", :question_type => "statement"}
      }
      put 'update', :form_id => @form.id, :id => @form.form_questions[0].id, :form_question => attribute[:form_question]
      updated_form_q = FormQuestion.where(:id => @form.form_questions[0].id).first
      updated_form_q.question.should eq "RSpec test question"
      updated_form_q.question_type.should eq "statement"
    end
  end
end