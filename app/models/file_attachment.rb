class FileAttachment < ActiveRecord::Base
  attr_accessible :filename, :content_type, :data, :file_type
  belongs_to :application
  
  validates :file_type, format: {:with => /^health_form$|^advertisement$/}, :allow_blank => true
  validates :filename, format: {:with => /.pdf$|.tiff$/}, :allow_blank => true
  validates :data, length: {:maximum => 4.megabytes}, :allow_blank => true

  def uploaded_file=(incoming_file)
    self.filename = incoming_file.original_filename
    self.content_type = incoming_file.content_type
    self.data = incoming_file.read
  end

  def filename=(new_filename)
    write_attribute("filename", sanitize_filename(new_filename))
  end

  private

  def sanitize_filename(filename)
    #get only the filename, not the whole path (from IE)
    just_filename = File.basename(filename)
    #replace all non-alphanumeric, underscore or periods with underscores
    just_filename.gsub(/[^\w\.\-]/, '_')
  end
end
