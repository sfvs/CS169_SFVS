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

    it "should detect a used e-mail" do
      user = FactoryGirl.create(:admin)
      expect(User.valid_email?("platoisaman@admin.com")).to be == false
    end

    describe "making applications" do
      before :each do
        @type = make_forms_for_app_type "sponsor"
        @user = FactoryGirl.create(:user)
        @app_year = stub_app_year 2015
      end

      it "should create an application" do
        User.any_instance.stub(:get_most_recent_application).and_return(nil)
        
        @user.create_an_application @type
        @user.reload
        @user.applications.count.should be == 1
      end

      it "should correctly delete the most recent application and create a new application" do
        mock_app = FactoryGirl.create(:application)
        mock_app.user = @user
        mock_app.year = @app_year
        mock_app.application_type = @type
        mock_app.completed = false
        mock_app.save

        @user.create_an_application @type

        Application.find_by_id(mock_app).should be_nil
        @user.get_most_recent_application.should_not be == mock_app
      end

      it "should be able to make a new application some new year in the future" do
        # ApplicationType.stub(:find_by_id).with(@reply).and_return(@type)
        old_year = stub_app_year 2015
        type_donor = make_forms_for_app_type "sponsor"
        @user.create_an_application type_donor

        new_year = stub_app_year 2018        
        @user.create_an_application @type
        @user.applications.length.should be == 2
      end
    end
  end

  it "should return list of users in the correct order" do
      users = [FactoryGirl.create(:user, :email => "c@hostname.com"), FactoryGirl.create(:user, :email => "a@hostname.com"), FactoryGirl.create(:user, :email => "b@hostname.com")]
      expect(User.get_users_by_order(:email)).to be == [users[1], users[2], users[0]]
    end

  it "should return list of email separated by ", "" do
    users = [FactoryGirl.create(:user, :email => "c@hostname.com"), FactoryGirl.create(:user, :email => "a@hostname.com"), FactoryGirl.create(:user, :email => "b@hostname.com")]
    expect(User.get_all_email_in_text(users)).to be == "c@hostname.com, a@hostname.com, b@hostname.com"
  end

  it "should format the telephone number in the correct format" do
    user = FactoryGirl.create( :user, :email => "malady@hostname.com")
    user.telephone = "5105121234"
    expect(user.format_phone_number).to be == "(510) 512-1234"
  end

  describe "filtering users" do
    before :each do
      @user = FactoryGirl.create :user, :email => "rspecftw@hostname.com"
    end

    make_a_vendor_application_for_user

    it "should return the list of users that have application of specified year" do
      expect(User.get_users_filtered_by(2015)).to be == [@user]
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
