require 'spec_helper'

describe Application do
  before(:each) do
    @app_year = stub_app_year 2015
    @type = make_forms_for_app_type "vendor"
    @mock_app = make_an_application @type, @app_year
  end

  describe "application function" do
    it "should be able to tell if an application has all forms are not completed" do
      results = {"a form" => true, "b form" => false}
      Application.any_instance.stub(:get_completed_forms).and_return(results)

      @mock_app.all_forms_completed?.should be_false
    end

    it "should be able to tell if an application is not completed with some unstarted forms" do
      results = {"a form" => true}
      Application.any_instance.stub(:get_completed_forms).and_return(results)

      @mock_app.all_forms_completed?.should be_false
    end

    it "should be able to tell if an application has all forms completed" do
      results = {"a form" => true, "b form" => true, "c form" => true}
      Application.any_instance.stub(:get_completed_forms).and_return(results)

      @mock_app.all_forms_completed?.should be_true
    end

    it "should give the current application time if not set" do
      Application.current_application_year.should == Time.now.year
    end
  end

  describe "content hashes" do
    it "should make content accessors work" do
      @mock_app.content = {:yourName => "John", :yourAge => 23}
      @mock_app.save!

      @mock_app.content["yourName"].should == "John"
      @mock_app.content["yourAge"].should == 23
    end

    it "should make complicated content work" do
      @mock_app.content = {:depth1 => {:depth2 => {:depth3 => "hello world"} } }
      @mock_app.save!

      @mock_app.reload()
      @mock_app.content["depth1"]["depth2"]["depth3"].should == "hello world"
    end

    it "should merge new contents with old one" do 
      @mock_app.content = {"Person1" => {"yourName" => "John", "yourLastName" => "Wick"}}
      @mock_app.save!

      @mock_app.add_content({"Person2" => {"yourName" => "Neo", "yourLastName" => "The Chosen One"}})
      @mock_app.reload
      @mock_app.content.should == {"Person1" => {"yourName" => "John", "yourLastName" => "Wick"}, "Person2" => {"yourName" => "Neo", "yourLastName" => "The Chosen One"}}
    end
  end

  describe "payment calculations" do
    it "should be able to calculate the total cost from a list of costs" do
      @mock_app.calculate_current_application_cost [["$22","hat"],["$12","shoe"]]
      @mock_app.amount_due.should be == 34
    end

    it "should be able to calculate payment based off of content" do
      @mock_app.content = {"some form 1" => {
        "a question without cost" => "hello",
        "question with cost" => "run ($77 electricity fee)"},
        "some form 2" => {
        "a question with fake cost" => "hi $321",
        "question with fake cost" => "ran ($45fee)",
        "question with cost but no description" => "ran ($45)",
        "another question with cost but no description 2" => "ran ($45 )",
        "another question with cost" => "tom ($11 chairs)"}
      }
      @mock_app.save!
      cost_description = @mock_app.grab_application_cost_description
      cost_description.should be == [["$77","electricity fee"],["$11","chairs"]]

      @mock_app.calculate_current_application_cost cost_description
      @mock_app.amount_due.should be == 88
    end

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
  
  describe "saving files" do
    file_fixture

    it "should not upload any files that do not have file_type health_form or advertisement" do
      @mock_app.save_file(@file, "random_type").should be_false
    end

    it "should create a new file_attachment and upload the health_form" do
      type = "health_form"
      FileAttachment.any_instance.stub(:find_by_file_type).with(type).and_return(nil)
      @mock_app.save_file @file, type
      expect(@mock_app.file_attachments.size).to be 1
    end
    
    it "should update an old health_form with a new uploaded file" do
      type = "advertisement"
      file = make_a_file_attachment @file
      FileAttachment.any_instance.stub(:find_by_file_type).and_return(file)
      @mock_app.save_file @file, type
      @mock_app.file_attachments[0].file_type.should == type
    end
  end
end
