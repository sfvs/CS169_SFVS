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

    it "should prefill the checkbox answer fields" do
      form_question = FactoryGirl.create :form_question
      subject.send(:get_answers_to_populate, form_question.question_type, form_question).should == ["Good!","Great!","Wonderful!"]
    end
  end

  describe "admin delete form question" do
    it "should delete the form question" do
      lambda do
        delete 'destroy', :form_id => @form.id, :id => @form.form_questions[0].id
      end.should change(FormQuestion, :count).by(-1)
    end

    it "should redirect to form content page after deleting form question" do
      delete 'destroy', :form_id => @form.id, :id => @form.form_questions[0].id
      response.should redirect_to '/admin/forms/' + @form.id.to_s + '/form_questions' 
    end
  end

  describe "form create form question" do
    it "should create a form question" do
      lambda do
        post 'create', :form_id => @form.id, :form_question => {}
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
      put 'sort', :form_id => @form.id, :order => {}
      response.should be_success
    end

    it "should update the order of the form questions" do
      order = {"0"=>{"id"=>"1", "position"=>"3"}, "1"=>{"id"=>"2", "position"=>"2"}, "2"=>{"id"=>"3", "position"=>"1"}}
      put 'sort', :form_id => @form.id, :order => order
      response.should be_success
      form_q = FormQuestion.where(:id => 1).first
      form_q.order.should eq 3
    end
  end
end