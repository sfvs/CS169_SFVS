require 'spec_helper'

describe Admin::FormQuestionsController do
  render_views
  login :admin

  describe "form questions index page" do
    it "should assign @form_questions" do
      form = make_form_with_questions
      get 'index', :form_id => form.id
      response.should be_success
      assigns(:form_questions).should == form.form_questions
    end
  end

  describe "form content edit page" do
    it "returns http success" do
      form = make_form_with_questions
      get 'edit', :form_id => form.id, :id => form.form_questions[0].id
      response.should be_success
    end

    it "should redirect to form content page when pressed Cancel" do
      form = make_form_with_questions
      put 'update', :form_id => form.id, :id => form.form_questions[0].id, :commit => 'Cancel'
      response.should redirect_to '/admin/forms/' + form.id.to_s + '/form_questions'
    end

    it "should redirect to form content page when pressed Update Form Question" do
      form = make_form_with_questions
      put 'update', :form_id => form.id, :id => form.form_questions[0].id, :form_question => {}
      response.should redirect_to '/admin/forms/' + form.id.to_s + '/form_questions'
    end
  end

  describe "admin delete form question" do
    it "should delete the form question" do
      form = make_form_with_questions
      lambda do
        delete 'destroy', :form_id => form.id, :id => form.form_questions[0].id
      end.should change(FormQuestion, :count).by(-1)
    end

    it "should redirect to form content page after deleting form question" do
      form = make_form_with_questions
      delete 'destroy', :form_id => form.id, :id => form.form_questions[0].id
      response.should redirect_to '/admin/forms/' + form.id.to_s + '/form_questions' 
    end
  end

  describe "form create form question" do
    it "should create a form question" do
      form = make_form_with_questions
      lambda do
        post 'create', :form_id => form.id, :form_question => {}
      end.should change(FormQuestion, :count).by(+1)
    end

    it "should redirect to form content page after creating form question" do
      form = make_a_form
      attribute = {
        :form_question => {:question => "Rspec test question", :question_type => "checkbox"}
      }
      checkbox_answers = {"0"=>"True", "1"=>"False", "2"=>"", "3"=>""}
      post 'create', :form_id => form.id, :form_question => attribute[:form_question], :check_answer => checkbox_answers
      response.should redirect_to '/admin/forms/' + form.id.to_s + '/form_questions' 
    end
  end

  describe "form sorting form question" do
    it "returns http success" do
      form = make_form_with_questions
      put 'sort', :form_id => form.id, :order => {}
      response.should be_success
    end
  end
end