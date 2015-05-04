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

  def update_application_with_response(payment, response, gross)
    payment_status = {"Complete" => Payment::PAYSTATUS_PAID, "Pending" => Payment::PAYSTATUS_PENDING}
 
    if (response != "VERIFIED" or (params[:payment_status] != "Complete" and params[:payment_status] != "Pending") )
      payment.pay_status = Payment::PAYSTATUS_DECLINED
      puts("PayPal could not verify the information provided by the user. Please manually inspect this payment.")
    else
      payment.pay_status = payment_status[params[:payment_status]]
      payment.amount_paid = gross
      payment.has_paid = true
      payment.txn_id = params[:txn_id]
      payment.pay_receipt = params.to_s + "RESULT = " + response.to_s
    end
    payment.save!
  end

  def params_are_valid?(payment)
    item_number = params[:invoice]
    txn_id = params[:txn_id]
    gross = params[:mc_gross].to_f

    (not item_number.empty?) and (payment.has_paid != true) and (payment.txn_id != txn_id) and (gross == payment.amount_due)
  end

  def verify_payment
    # lookup the application by invoice number/item number
    payment = Payment.find_by_invoice_number!(params[:invoice])

    if (not params_are_valid?(payment))
      puts("invalid post request. Canceling transaction.")
    else
      puts("RAW PAYPAL REQUEST: " + request.raw_post)
      result = get_paypal_response(request.raw_post)
      update_application_with_response(payment, result, params[:mc_gross].to_f)
    end

    redirect_to root_path
  end

  def thankyou
    flash[:notice] = "Thank you for submitting your payment. Please see the status of your payment below."
    redirect_to root_path
  end
end