require 'spec_helper'

describe Admin::UsersController do

  login :admin

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

    it "should redirect to admin root after deleting user" do
      user = make_a_member :user, :email => "user1@hostname.com"
      delete 'destroy', :id => user.id
      response.should redirect_to '/admin'
    end
  end  
end
