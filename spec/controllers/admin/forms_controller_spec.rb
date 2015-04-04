require 'spec_helper'

describe Admin::FormsController do
  render_views
  login :admin

  describe "admin forms page" do
    it "should assign @forms to the list of existing forms" do
      forms = make_many_forms
      get 'index'
      assigns(:forms).should == forms
    end

    it "should return a list of forms' names" do
      form = make_a_form
      get 'index'
      expect(response.body).to include(form.form_name)
    end
  end
end