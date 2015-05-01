class FileAttachmentController < ApplicationController

  def download_file
    @attachment = FileAttachment.find_by_file_type(params[:file_type])
    send_data @attachment.data, :filename => @attachment.filename, :type => @attachment.content_type
  end

  def upload_file
    incoming_file = params[:file_attachment]
    type = params[:file_type]
    if incoming_file.blank?
      flash[:alert] = "There was nothing uploaded."
      redirect_to user_path
      return
    end

    application = User.find_by_id(params[:id]).get_most_recent_application

    attachment = application.file_attachments.find_by_file_type(type)
    if attachment.nil?
      attachment = application.file_attachments.build
      attachment.file_type = type
    end
    attachment.uploaded_file = incoming_file
    if attachment.save
      flash[:notice] = "Thank you for your submission..."
    else
      flash[:alert] = "There was a problem submitting your attachment."
    end
    redirect_to user_path
  end

end
