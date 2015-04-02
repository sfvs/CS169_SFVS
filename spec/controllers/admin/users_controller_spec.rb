require 'spec_helper'

describe Admin::UsersController do
  render_views
  login :admin

  describe "admin users page" do
    it "should assign @users to the list of regular users" do
        users = make_many_members
        get 'index'
        response.should be_success
        assigns(:users).should == users
    end

    it "should return a list of users' email addresses" do
        user = make_a_member(:user, :email => "shrek_is_love@shrek_is_life.com") 
        get 'index'
        expect(response.body).to include(user.email)
    end

    it "should have a 'Create User' button" do
        get 'index'
        expect(response.body).to include("Create User")
    end
  end

  describe "admin edit page" do
    it "returns http success" do
      user = make_a_member :user, :email => "user1@hostname.com"
      get 'edit', :id => user.id
      response.should be_success
    end

    it "should assign @user" do
      user = make_a_member :user, :email => "user1@hostname.com"
      get 'edit', :id => user.id
      response.should be_success
      assigns(:user).should == user
    end
  end

  describe "admin show user content page" do
    it "returns http success" do
      user = make_a_member :user, :email => "user1@hostname.com"
      get 'show', :id => user.id
      response.should be_success
    end

    it "should assign @user" do 
      user = make_a_member :user, :email => "user1@hostname.com"
      get 'show', :id => user.id
      response.should be_success
      assigns(:user).should == user
    end
  end

  describe "admin delete user" do
    it "should delete the user" do
      user = make_a_member :user, :email => "user1@hostname.com"
      lambda do
        delete 'destroy', :id => user.id
      end.should change(User, :count).by(-1)
    end

    it "should redirect to admin users list page after deleting user" do
      user = make_a_member :user, :email => "user1@hostname.com"
      delete 'destroy', :id => user.id
      response.should redirect_to '/admin/users'
    end
  end 

  describe "admin show user content page" do 
    it "should route to show user content page" do
      user = make_a_member :user
      expect(:get => "admin/users/#{user.id}").to route_to(:controller => "admin/users", :action => "show", :id => "#{user.id}")
    end
  end

  describe "admin user edit page" do
    it "should route to user edit page" do
      user = make_a_member :user
      expect(:get => "admin/users/#{user.id}/edit").to route_to(:controller => "admin/users", :action => "edit", :id => "#{user.id}")
    end
  end

  describe "admin create user page" do
    it "should route to create new user page" do
      expect(:get => "admin/users/new").to route_to(:controller => "admin/users", :action => "new")
    end
  end 
end
