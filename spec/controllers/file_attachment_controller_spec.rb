require 'spec_helper'

describe FileAttachmentController do
  login(:user, :email => "i_am_a_coconut@mail.com")
  make_a_vendor_application_for_user
  file_fixture

  describe "uploading files" do
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
    it "should successfully download if a file attachment exists" do
      file = make_a_file_attachment @file
      type = "health_form"

      FileAttachment.stub(:find_by_file_type).with(type).and_return(file)
      get :download_file, :id => @user.id, :file_type => type
      response.should be_success
    end
  end
end
