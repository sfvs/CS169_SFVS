class FileAttachment < ActiveRecord::Base
  attr_accessible :filename, :content_type, :data, :file_type
  belongs_to :application
  
  validate :check_valid_file_type
  validate :check_file_extension
  validate :check_file_size_limit

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

  def check_valid_file_type
    if self.file_type.match(/^health_form$|^advertisement$/).nil?
      errors.add(:file_type, 'File type is not a Health Form or an Advertisement')
    end
  end

  def check_file_extension
    if self.content_type.match(/application\/pdf|image\/tiff/).nil?
      errors.add(:file_ext, 'Content Type is not pdf or tiff.')
    end
  end

  def check_file_size_limit
    if self.data.size > 4.megabytes
      errors.add(:file_size, 'File size cannot be over four megabyte.')
    end
  end

end
