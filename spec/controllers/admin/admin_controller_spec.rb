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
        get 'index'
        expect(response).to render_template("index")
      end

      it "should have a logout button" do
        get 'index'
        expect(response.body).to include("Logout")
      end
    end
  end
end
