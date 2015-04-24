require 'spec_helper'

describe Application do

  describe "application function" do
    it "should be able to tell if an application has all forms are not completed" do
      myApp = Application.new
      results = {"a form" => true, "b form" => false}
      Application.any_instance.stub(:get_completed_forms).and_return(results)

      myApp.all_forms_completed?.should be_false
    end

    it "should be able to tell if an application has all forms completed" do
      myApp = Application.new
      results = {"a form" => true, "b form" => true}
      Application.any_instance.stub(:get_completed_forms).and_return(results)

      myApp.all_forms_completed?.should be_true
    end
  end

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

	it "should save the amount paid" do
		myApp = Application.new
		myApp.year = 2015
		myApp.content = {"Person1" => {"yourName" => "John", "yourLastName" => "Wick"}}
		myApp.amount_paid = 250.0
		myApp.save!

		myApp.reload
		myApp.hasPaid?.should == true
		myApp.getAmountPaid.should == 250.0
	end

  describe "payment calculations" do
    it "should be able to calculate payment based off of content" do
      type = make_forms_for_app_type "vendor"
      mock_app = make_an_application(type, 2015)
      mock_app.content = {"some form 1" => {
        "a question without cost" => "hello",
        "question with cost" => "run ($23)"},
        "some form 2" => {
        "a question with fake cost" => "hi $321",
        "question with fake cost" => "ran ($453 fee)",
        "another question with cost" => "tom ($11)"}
      }
      mock_app.save!
      mock_app.calculate_current_application_cost
      mock_app.getAmountPaid.should be == 34
    end
  end

  describe "sanitizing the user inputs" do
    it "should remove double quotes and remove any dollar signs" do
      type = FactoryGirl.create(:application_type,{:app_type => "vendor"})
      type.forms << make_many_forms(1)
      mock_app = make_an_application(type, 2015)
      mock_form = type.forms[0]
      Form.stub(:find_by_form_name).and_return(mock_form)

      form_content = {}
      mock_form.form_questions.each do |question|
        form_content[question.question] = 'some answer"sdfwef"fwe$$2dfsf$$vsdv'
      end
      safe_content = mock_app.sanitize_form_content(mock_form.form_name, form_content)

      safe_content.each do |k,v|
        form_content[k].should_not match /["$]/
      end
    end
  end

end
