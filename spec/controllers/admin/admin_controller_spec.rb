require 'spec_helper'

describe Admin::AdminController do
  # Use factory girl after describe to get users for the RSpec tests
  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end

    pending "should return a list of users' email addresses" #do
      #users = [stub_model(User), stub_model(User)]
    #end
  end
end
