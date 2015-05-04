class FileAttachmentController < ApplicationController

  before_filter :validate_user_authorization, :only => :upload_file
  before_filter :require_admin, :only => :download_file

  def send_health_form
    send_file 'app/assets/files/health_permit_form.pdf'
  end

  def download_file
    @attachment = FileAttachment.where("application_id = ?", params[:id]).find_by_file_type(params[:file_type])
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
