require 'spec_helper'

describe User do
  describe "user functions" do

    it "tells me what is my most recent application" do
      #create user
      user = FactoryGirl.create(:user)
      app1 = user.applications.create :completed => true
      app2 = user.applications.create
      expect(user.get_most_recent_inprogress_application).to be == app2
    end

  end
end
