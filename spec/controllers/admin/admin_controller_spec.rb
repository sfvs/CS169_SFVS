require 'spec_helper'

describe Admin::AdminController do
  # Use factory girl after describe to get users for the RSpec tests
  render_views
  describe "admin index page" do
    
    it "returns http success" do
      get 'index'
      response.should be_success
    end

    it "should render the admin index template" do
      get :index
      expect(response).to render_template("index")
    end

    it "should return a list of users' email addresses" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = FactoryGirl.create(:user)
      get 'index'
      expect(response.body).to include(user.email)
    end

    it "should have a logout button" do
      get 'index'
      expect(response.body).to include("Logout")
    end

    it "should have a 'Create User' button" do
      get 'index'
      expect(response.body).to include("Create User")
    end
  end

  describe "admin show user content page" do 
    it "should route to show user content page" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = FactoryGirl.create(:user)
      expect(:get => "/admin/users/1").to route_to(:controller => "admin/users", :action => "show", :id => "1")
    end
  end

  describe "admin user edit page" do
    it "should route to user edit page" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = FactoryGirl.create(:user)
      expect(:get => "/admin/users/1/edit").to route_to(:controller => "admin/users", :action => "edit", :id => "1")
    end
  end

  describe "admin create user page" do
    it "should route to create new user page" do
      expect(:get => "/admin/users/new").to route_to(:controller => "admin/users", :action => "new")
    end
  end
end
