class UsersController < ApplicationController

  before_filter :validate_user_authorization

  def show
    @user = User.find(params[:id])
    @application = @user.get_most_recent_application
    if @application
      @completed_forms = @application.get_completed_forms
      if @application.approved
        @status = "Complete"
      elsif @application.completed
        @status = "Submitted - In Review"
      else
        @status = "Incomplete"
      end
      @year = @application.year
      @type = @application.application_type.app_type
      @forms_to_build = @application.application_type.forms
      unless @application.has_paid
        @cost_description = @application.grab_application_cost_description
        @application.calculate_current_application_cost @cost_description
        @application_cost = @application.amount_paid
      end
    end
  end

  def submit_application
    user = User.find(params[:id])
    application = user.get_most_recent_application
    if application
      if not application.completed and application.all_forms_completed? 
        application.completed = true
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
		if not application.completed
			flash[:alert] = "You must first complete and submit the application."
			redirect_to user_path(user)
			return
		end
		if application.has_paid
			#flash[:payment_notice] = "You have already paid for this application."
			flash[:alert] = "You have already paid for this application."
			redirect_to user_path(user)
		else
			redirect_to get_paypal_url(user)
		end
	end
	# sfvs.org/verify_payment/id

	def verify_payment
		user = User.find(params[:id])
		application = user.get_most_recent_application
		#if (! application.completed)
		#	flash[:payment_notice] = "You must submit your application before paying."
		#	redirect_to user_path(user)
		#	return
		#end

		application.amount_paid = 150.00
		# iteration 4-1 NOTE:
		# We need to send a POST request to PayPal to check the -actual- payment status.
		application.save!
		
		flash[:notice] = "Payment received. Thank you!"
		flash.keep
		redirect_to user_path(user)
		# vefify payment
	end

  private

	def get_paypal_url(user)
		timestamp = Time.now.to_i
		values = {
        business: "sfvsteam-business@gmail.com",
        cmd: "_xclick",
        upload: 1,
        return: "https://sfvsapp.herokuapp.com/users/#{user.id}/verify_payment/",
        invoice: "#{timestamp}" + "#{user.get_most_recent_application.id}",
        amount: 150.00, # Update this in iteration 4-1: needs to calculate real amount due
        item_name: "SFVS Registration Fee",
        item_number: 0,
        quantity: '1'
    }

		return "https://www.sandbox.paypal.com/cgi-bin/webscr?" + values.to_query
	end
  
end
