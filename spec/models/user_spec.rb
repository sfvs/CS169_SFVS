require 'spec_helper'

describe User do
  describe "user functions" do

    it "tells me what is my most recent application" do
      #create user
      app_year = stub_app_year 2015
      user = FactoryGirl.create(:user)
      app1 = user.applications.create :completed => true, :year => 2014
      app2 = user.applications.create :year => app_year
      expect(user.get_most_recent_application).to be == app2
    end

    it "should return the most recent app for the current year" do
      app_year = stub_app_year 2015
      user = FactoryGirl.create(:user)

      app1 = user.applications.create :year => app_year
      expect(user.get_most_recent_application).to be == app1

      app_year = stub_app_year 2016
      expect(user.get_most_recent_application).to be_nil
    end
  end

  describe "deleting a user" do
    it "remove every application that user has" do
      app_year = stub_app_year 2015
      user = FactoryGirl.create(:user)
      app1 = user.applications.create :year => app_year

      user.destroy
      User.find_by_id(user.id).should be_nil
      Application.find_by_id(app1.id).should be_nil
    end
  end

end
