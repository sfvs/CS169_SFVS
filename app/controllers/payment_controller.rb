class PaymentController < ActionController::Base
	# this controller method should be called
	# by PayPal from the notification hook
	skip_before_filter :verify_authenticity_token, :only => [:verify_payment]

	def verify_payment
		# lookup the application by invoice number/item number
		item_number = params[:item_number]
		if (item_number.empty?)
			logger.warn("A user tried to make a payment with an empty invoice number. Canceling transaction.")
			redirect_to root_path
			return
		end

		application = Application.find_by_invoice_number!(item_number)
		txn_id = params[:txn_id]
		if (application.has_paid == true or application.payment_id == txn_id)
			logger.warn("A user attempted to pay for an application that has already been paid for. Canceling transaction.")
			redirect_to root_path
			return
		end

		# verify amount_due == mc_gross (from paypal/post)
		gross = params[:mc_gross].to_f
		if (gross != application.amount_due)
			logger.warn("A user attempted to forge a payment. Canceling transaction.")
			redirect_to root_path
			return
		end

		# we need to send a post request to PayPal with the txn_id to get the info
		# and verify that the payment info is correct
		paypal_url_cmd = "https://www.sandbox.paypal.com/cgi-bin/webscr"
		req_body = "cmd=_notify-validate&" + request.raw_post
		url = URI.parse(paypal_url_cmd)
		req = Net::HTTP::Post.new(url.path)	
		req.body = req_body
		http = Net::HTTP.new(url.host, url.port)
		http.use_ssl = true
		result = http.request(req)
		
		# make sure paypal verified this payment info
		if (result.body.to_s != "VERIFIED")
			application.pay_status = 3 # rejected, please manually inspect
			application.save!
			logger.warn("PayPal could not verify the information provided by the user. Please manually inspect this payment.")
			redirect_to root_path
			return
		end
		
		# update the application with amount paid and pay status
		application.amount_paid = gross
		application.has_paid = true
		if (params[:payment_status] == "Completed")
			application.pay_status = 2
		elsif (params[:payment_status] == "Pending")
			application.pay_status = 1
		else
			application.pay_status = 3
		end

		application.payment_id = txn_id
		application.pay_receipt = params.to_s + "PayPal Response: " + result.body.to_s
		application.save!

		redirect_to root_path
	end

	def thankyou
		flash[:success] = "Thank you for submitting your payment. Please see the status of your payment below."
		redirect_to root_path
	end
end
