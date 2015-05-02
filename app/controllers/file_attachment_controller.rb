class FileAttachmentController < ApplicationController

  def download_file
    @attachment = FileAttachment.find_by_file_type(params[:file_type])
    send_data @attachment.data, :filename => @attachment.filename, :type => @attachment.content_type
  end

  def upload_file
    incoming_file = params[:file_attachment]
    if incoming_file.blank?
      flash[:alert] = "There was nothing to upload."
      redirect_to user_path
      return
    end
    
    application = User.find_by_id(params[:id]).get_most_recent_application
    if application.save_file incoming_file, params[:file_type]
      flash[:notice] = "Thank you for your submission..."
    else
      flash[:alert] = "There was a problem submitting your attachment."
    end
    redirect_to user_path
  end

end
