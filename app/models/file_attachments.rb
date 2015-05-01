class FileAttachments < ActiveRecord::Base
  attr_accessible :filename, :content_type, :data, :file_type
  belongs_to :applications
end
