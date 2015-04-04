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
end