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

    it "should not save if filename does not have extension pdf or tiff, but save otherwise" do
      file = FileAttachment.new
      file.filename = "aform.pdf"
      file.save.should be_true

      file = FileAttachment.new
      file.filename = "aform.tiff"
      file.save.should be_true

      file = FileAttachment.new
      file.filename = "aform.doc"
      file.save.should be_false
    end
  end
end
