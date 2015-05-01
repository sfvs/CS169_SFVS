class FileAttachmentController < ApplicationController

  def upload_file
    return if params[:file_attachment].blank?
    incoming_file = params[:file_attachment]

    @attachment = FileAttachments.create
    @attachment.filename = File.basename(incoming_file.original_filename)
    @attachment.content_type = incoming_file.content_type
    @attachment.data = incoming_file.read 

    if @attachment.save
        flash[:notice] = "Thank you for your submission..."
    else
        flash[:error] = "There was a problem submitting your attachment."
    end
    redirect_to user_path
  end

end
