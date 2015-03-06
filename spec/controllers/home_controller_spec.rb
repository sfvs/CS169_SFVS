require 'spec_helper'

describe HomeController do
	describe "login from the homepage" do
	  it "routes root (homepage) to the home controller" do
	    expect(:get => "/").to route_to(:controller => "home", :action => "index")
	  end
	end
end
