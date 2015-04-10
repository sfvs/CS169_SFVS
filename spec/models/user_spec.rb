require 'spec_helper'

describe User do
  describe "user functions" do

    it "tells me what is my most recent application" do
      #create user
      user = FactoryGirl.create(:user)
      Application.latest_year = 2015
      app1 = user.applications.create :completed => true, :year => 2014
      app2 = user.applications.create :year => 2015
      expect(user.get_most_recent_application).to be == app2
    end

  end
end
