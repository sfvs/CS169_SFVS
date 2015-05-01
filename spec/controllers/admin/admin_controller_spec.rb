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

      it "should have a link to users list" do
        get 'index'
        expect(response.body).to include("Users List")
      end

      it "should have a link to forms list" do
        get 'index'
        expect(response.body).to include("Forms List")
      end
    end

    describe "changing the application year" do
      after :each do
        # resetting class variables
        Application.current_application_year = Time.now.year
      end
      it "should correctly update with a valid year" do
        Application.current_application_year = 2000

        put 'update_app_year', :app_year => "2001"
        Application.current_application_year.should be == 2001
      end

      it "should do nothing for an invalid year" do
        Application.current_application_year = 2000

        put 'update_app_year', :app_year => "20000"
        Application.current_application_year.should be == 2000
        put 'update_app_year', :app_year => "2230a"
        Application.current_application_year.should be == 2000
      end
    end
  end
end
