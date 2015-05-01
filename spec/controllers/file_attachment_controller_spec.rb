require 'spec_helper'

describe FileAttachmentController do
  login(:user, :email => "i_am_a_coconut@mail.com")
  make_a_vendor_application_for_user

  before :each do
    @file = fixture_file_upload('/files/health_permit_form.pdf', 'application/pdf')
  end

  describe "uploading files" do
    it "should not upload any files that do not have file_type health_form or advertisement" do
      post :upload_file, :id => @user.id, :file_type => "random_type", :file_attachment => @file
      expect(flash[:alert].empty?).to be_false
    end

    it "should create a new file_attachment and upload the health_form" do
      type = "health_form"
      User.stub(:get_most_recent_application).and_return(@mock_app)
      FileAttachment.any_instance.stub(:find_by_file_type).with(type).and_return(nil)

      post :upload_file, :id => @user.id, :file_type => type, :file_attachment => @file
      expect(@mock_app.file_attachments.size).to be 1
    end
    
    it "should update an old health_form with a new uploaded file" do
      type = "advertisement"
      file = make_a_file_attachment @file
      User.stub(:get_most_recent_application).and_return(@mock_app)
      FileAttachment.any_instance.stub(:find_by_file_type).and_return(file)

      post :upload_file, :id => @user.id, :file_type => type, :file_attachment => @file
      @mock_app.file_attachments[0].file_type.should == type
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
