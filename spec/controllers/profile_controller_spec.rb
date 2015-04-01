require 'spec_helper'

describe ProfileController do
	describe "test the profile page" do

		user = sign_in make_a_member(:user, :email => "i_am_a_coconut@mail.com")
		login :user

    	#Test logout feature
    	it "should route a user to the login page if logout is pressed" do

    	end

    	#Test Take Survey 
    	it "should route a user to the survey page if the survey button is pressed" do

    	end

    	#Test if correct e-mail shows up 
    	it "should display the correct e-mail on the user page" do

    	end 
  	end 
end 