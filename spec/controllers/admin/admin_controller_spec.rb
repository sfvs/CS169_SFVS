require 'spec_helper'

describe Admin::AdminController do
  # Use factory girl after describe to get users for the RSpec tests
  render_views
  describe "successful admin login" do
    
    login :admin

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
        user = make_a_member(:user, :email => "shrek_is_love@shrek_is_life.com") 
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
        user = make_a_member :user
        expect(:get => "/admin/users/#{user.id}").to route_to(:controller => "admin/users", :action => "show", :id => "#{user.id}")
      end
    end

    describe "admin user edit page" do
      it "should route to user edit page" do
        user = make_a_member :user
        expect(:get => "/admin/users/#{user.id}/edit").to route_to(:controller => "admin/users", :action => "edit", :id => "#{user.id}")
      end
    end

    describe "admin create user page" do
      it "should route to create new user page" do
        expect(:get => "/admin/users/new").to route_to(:controller => "admin/users", :action => "new")
      end
    end
  end
end
