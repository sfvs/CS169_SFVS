class UsersController < ApplicationController

  before_filter :validate_user_authorization
  
  @@messages = {
    Application::PAYSTATUS_UNPAID => "Not Paid",
    Application::PAYSTATUS_PENDING => "Pending", 
    Application::PAYSTATUS_PAID => "Payment received! Thank you!",
    Application::PAYSTATUS_DECLINED => "An error occurred while processing your payment. While your application is submitted, you will need to contact support to submit payment."
  }

  def show
    @user = User.find(params[:id])
    @application = @user.get_most_recent_application
    if @application
      @completed_forms = @application.get_completed_forms
      @status = @application.completition_status
      @year = @application.year
      @type = @application.application_type.app_type
      @forms_to_build = @application.application_type.forms
      
      @health_form_file = @application.file_attachments.find_by_file_type(:health_form)
      @advertisement_file = @application.file_attachments.find_by_file_type(:advertisement)
      @payment = @application.payment

      unless @payment.has_paid
        @cost_description = @application.grab_application_cost_description
        @application.calculate_current_application_cost @cost_description
        @application_cost = @payment.amount_due
      end

      @application_status_msg = @@messages[@payment.pay_status]
    end
  end

  def submit_application
    user = User.find(params[:id])
    application = user.get_most_recent_application
    if application
      if not application.completed and application.all_forms_completed? 
        application.completed = true
        application.submitted_at = Time.now
        application.save
        flash[:notice] = "Application successfully submitted."
      else
        flash[:alert] = "One or more forms have yet to be submitted."
      end
    else
      flash[:alert] = "Error. Application not found. Please contact SFVS for help."
    end
    redirect_to user_path(user)
  end

  def submit_payment
    user = User.find(params[:id])
    application = user.get_most_recent_application
    payment = application.payment
    if (payment.invoice_number.empty?)
      timestamp = Time.now.to_i
      payment.invoice_number = "#{timestamp}" + "#{application.id}"
      payment.save!
    end
    if not application.completed || payment.has_paid
      if not application.completed
        flash[:alert] = "You must first complete and submit the application."
      else
        flash[:alert] = "You have already paid for this application."
      end
      redirect_to user_path(user)
    else
      redirect_to get_paypal_url(payment)
    end
  end

  private

  def get_paypal_url(payment)
    base_url = request.protocol + request.host
    values = {
        business: "sfvsteam-business@gmail.com",
        cmd: "_xclick",
        upload: 1,
        return: base_url + "/payment_receipt",
        invoice: payment.invoice_number,
        amount: payment.amount_due,
        item_name: "SFVS Registration Fee",
        item_number: payment.invoice_number,
        quantity: '1',
        notify_url: base_url + "/verify_payment"
    }

    return "https://www.sandbox.paypal.com/cgi-bin/webscr?" + values.to_query
  end
end
