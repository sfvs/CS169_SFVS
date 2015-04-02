require 'spec_helper'

describe Admin::FormsController do
  render_views
  login :admin

  describe "admin forms page" do
    it "should assign @forms to the list of existing forms" do
        forms = make_many_forms
        get 'index'
        response.should be_success
        assigns(:forms).should == forms
    end

    it "should return a list of forms' names" do
        form = make_a_form
        get 'index'
        expect(response.body).to include(form.form_name)
    end

    it "should have a 'Create Form' button" do
        get 'index'
        expect(response.body).to include("Create Form")
    end
  end

  describe "admin form edit page" do
    it "returns http success" do
      form = make_a_form
      get 'edit', :id => form.id
      response.should be_success
    end

    it "should assign @form" do
      form = make_a_form
      get 'edit', :id => form.id
      response.should be_success
      assigns(:form).should == form
    end
  end

  describe "admin show form content page" do
    it "returns http success" do
      form = make_a_form
      get 'show', :id => form.id
      response.should be_success
    end

    it "should assign @form" do 
      form = make_a_form
      get 'show', :id => form.id
      response.should be_success
      assigns(:form).should == form
    end
  end

  describe "admin delete form" do
    it "should delete the form" do
      form = make_a_form
      lambda do
        delete 'destroy', :id => form.id
      end.should change(Form, :count).by(-1)
    end

    it "should redirect to admin forms list page after deleting form" do
      form = make_a_form
      delete 'destroy', :id => form.id
      response.should redirect_to '/admin/forms'
    end
  end 
end