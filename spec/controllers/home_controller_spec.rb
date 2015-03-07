require 'spec_helper'

describe HomeController do
  describe "login feature from the homepage" do
    it "routes root (homepage) to the home controller" do
      expect(:get => "/").to route_to(:controller => "home", :action => "index")
    end

    it "should route a signed in user to the user page" do
      user = sign_in # helper function sign_in from spec/support/controller_macros.rb 
      get :index
      expect(response).to redirect_to user_path(user)
    end

    it "should route users not signed in to the login page" do
      sign_in nil
      get :index
      expect(response).to redirect_to new_user_session_path
    end
  end
end
