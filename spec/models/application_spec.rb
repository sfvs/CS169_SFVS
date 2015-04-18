require 'spec_helper'

describe Application do

  # describe "application function" do
  #   it "should be able to tell if an application has all forms are not completed" do
  #     myApp = Application.new
  #     results = {"a form" => true, "b form" => false}
  #     myApp.stub(:get_completed_forms).and_return(results)

  #     myApp.all_forms_completed?.should be_false
  #   end

  #   it "should be able to tell if an application has all forms completed" do
  #     myApp = Application.new
  #     results = {"a form" => true, "b form" => true}
  #     myApp.stub(:get_completed_forms).and_return(results)

  #     myApp.all_forms_completed?.should be_true
  #   end
  # end

  it "should be able to be created successfully" do
    myApp = Application.new
    myApp.year.should == nil
    myApp.content.should == {}
    myApp.completed.should == false
  end

  it "should make content accessors work" do
    myApp = Application.new
    myApp.year = 2015
    myApp.content = {:yourName => "John", :yourAge => 23}
    myApp.save!

    myApp.content["yourName"].should == "John"
    myApp.content["yourAge"].should == 23
  end

  it "should make complicated content work" do
    myApp = Application.new
    myApp.content = {:depth1 => {:depth2 => {:depth3 => "hello world"} } }
    myApp.save!

    myApp.reload()
    myApp.content["depth1"]["depth2"]["depth3"].should == "hello world"
  end

  it " should give the current applicationt time" do
    @test_time = Time.parse("2011-1-2")
    Time.stub(:now).and_return(@test_time)

    Application.current_application_year.should == @test_time.year
  end

  it "should merge new contents with old one" do 
    myApp = Application.new
    myApp.year = 2015
    myApp.content = {"Person1" => {"yourName" => "John", "yourLastName" => "Wick"}}
    myApp.save!

    myApp.add_content({"Person2" => {"yourName" => "Neo", "yourLastName" => "The Chosen One"}})
    myApp.reload
    myApp.content.should == {"Person1" => {"yourName" => "John", "yourLastName" => "Wick"}, "Person2" => {"yourName" => "Neo", "yourLastName" => "The Chosen One"}}
  end

end
