require 'spec_helper'

describe HomeController do
  describe "login feature from the homepage" do
    it "routes root (homepage) to the home controller" do
      expect(:get => "/").to route_to(:controller => "home", :action => "index")
    end

    it "should route a signed in user to the user page" do
      user = double('user')
      allow(request.env['warden']).to receive(:authenticate!) { user }
      allow(controller).to receive(:current_user) { user }
      get :index
      expect(response).to redirect_to user_path(user)
    end

    it "should route users not signed in to the login page" do
      allow(request.env['warden']).to receive(:authenticate!).and_throw(:warden, {:scope => :user})
      allow(controller).to receive(:current_user).and_return(nil)
      get :index
      expect(response).to redirect_to new_user_session_path
    end
  end
end
