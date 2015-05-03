require 'spec_helper'

describe FileAttachment do
  describe "file attachment validations" do
    it "should not save if file type is not health_form or advertisement, but save otherwise" do
      file = FileAttachment.new
      file.file_type = "health_form"
      file.save.should be_true

      file.file_type = "my_form"
      file.save.should be_false
    end

    it "should not save if content_type is not pdf or tiff, but save otherwise" do
      file = FileAttachment.new
      file.content_type = "application/pdf"
      file.save.should be_true
    end
  end
end
