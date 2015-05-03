require 'net/http'
require 'net/https'
require 'uri'

class PaymentController < ActionController::Base
  # this controller method should be called
  # by PayPal from the notification hook
  skip_before_filter :verify_authenticity_token, :only => [:verify_payment]

  def get_paypal_response(query)
    paypal_url_cmd = "https://www.sandbox.paypal.com/cgi-bin/webscr"
    req_body = "cmd=_notify-validate&" + query
    url = URI.parse(paypal_url_cmd)
    req = Net::HTTP::Post.new(url.path) 
    req.body = req_body
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    result = http.request(req)

    return result.body.to_s
  end

  def update_application_with_response(application, response, gross)
    payment_status = {"Complete" => Application::PAYSTATUS_PAID, "Pending" => Application::PAYSTATUS_PENDING}
 
    if (response != "VERIFIED" or (params[:payment_status] != "Complete" and params[:payment_status] != "Pending") )
      application.pay_status = Application::PAYSTATUS_DECLINED
      print("PayPal could not verify the information provided by the user. Please manually inspect this payment.")
    else
      application.pay_status = payment_status[params[:payment_status]]
      application.amount_paid = gross
      application.has_paid = true
      application.payment_id = params[:txn_id]
      application.pay_receipt = params.to_s + "RESULT = " + response.to_s
    end
    application.save!
  end

  def params_are_valid?(application)
    item_number = params[:invoice]
    txn_id = params[:txn_id]
    gross = params[:mc_gross].to_f

    (not item_number.empty?) and (application.has_paid != true) and (application.payment_id != txn_id) and (gross == application.amount_due)
  end

  def verify_payment
    # lookup the application by invoice number/item number
    application = Application.find_by_invoice_number!(params[:invoice])

    if (not params_are_valid?(application))
      print("invalid post request. Canceling transaction.")
    else
      print("RAW PAYPAL REQUEST: " + request.raw_post)
      result = get_paypal_response(request.raw_post)
      update_application_with_response(application, result, params[:mc_gross].to_f)
    end

    redirect_to root_path
  end

  def thankyou
    flash[:success] = "Thank you for submitting your payment. Please see the status of your payment below."
    redirect_to root_path
  end
end