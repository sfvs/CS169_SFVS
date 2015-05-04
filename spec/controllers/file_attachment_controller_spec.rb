require 'spec_helper'

describe FileAttachmentController do
  file_fixture

  describe "uploading files" do
    login(:user, :email => "i_am_a_coconut@mail.com")
    make_a_vendor_application_for_user
    it "should not upload empty files" do
      post :upload_file, :id => @user.id, :file_type => "health_form", :file_attachment => nil
      expect(@mock_app.file_attachments.size).to be 0
    end

    it "should not upload an invalid file" do
      type = "health_form"
      User.stub(:get_most_recent_application).and_return(@mock_app)
      Application.any_instance.stub(:save_file).and_return(false)

      post :upload_file, :id => @user.id, :file_type => type, :file_attachment => @file
      expect(flash[:alert].empty?).to be_false
    end
    
    it "should correctly upload a file" do
      type = "health_form"
      User.stub(:get_most_recent_application).and_return(@mock_app)
      Application.any_instance.stub(:save_file).and_return(true)

      post :upload_file, :id => @user.id, :file_type => type, :file_attachment => @file
      expect(flash[:notice].empty?).to be_false
    end
  end

  describe "download files" do
    login :admin

    before :each do
      type = make_forms_for_app_type "vendor"
      year = stub_app_year 2015
      @app1 = make_an_application(type,year)
      @app2 = make_an_application(type,year)

      @file_type = "health_form"
      @file1 = make_a_file_attachment @file
      @file1.update_attribute(:file_type, @file_type)
      @file2 = make_a_file_attachment @file
      @file2.update_attribute(:file_type, @file_type)
      @file3 = make_a_file_attachment @file
      @file3.update_attribute(:file_type, "advertisement")
    end

    it "should find the correct health form for the specific app if there are multiple forms in the db" do
      @app1.file_attachments << @file1
      @app2.file_attachments << @file2

      get :download_file, :id => @app2.id, :file_type => @file_type
      assigns(:attachment).should be == @file2
      response.should be_success
    end

    it "should successfully download the health_form assuming app has both ad and health forms uploaded" do
      @app2.file_attachments << [@file3,@file2]
      
      get :download_file, :id => @app2.id, :file_type => @file_type
      assigns(:attachment).should be == @file2
      response.should be_success
    end
  end
end
