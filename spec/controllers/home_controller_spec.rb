require 'spec_helper'

describe HomeController do
  describe "login feature from the homepage" do
    it "routes root (homepage) to the home controller" do
      expect(:get => "/").to route_to(:controller => "home", :action => "index")
    end

    it "should route a signed in user to the user page" do
      user = make_a_member(:user, :email => "i_am_a_coconut@mail.com") 
      get :index
      expect(response).to redirect_to user_path(user)
    end
  
    it "should route users not signed in to the login page" do
      sign_in nil
      get :index
      expect(response).to redirect_to new_user_session_path
    end

    it "should route admin to the admin page" do
      admin = make_a_member(:admin)
      get :index 
      expect(response).to redirect_to admin_users_path
    end
  end
end
