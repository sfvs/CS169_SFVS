require 'spec_helper'
require 'rack/utils'

describe PaymentController do
  login(:user, :email => "i_am_a_coconut@mail.com")

  describe "submitting a payment" do
    it "should fail with invalid param argument" do
      expect { post :verify_payment, {:item_numb => "abc123" } }.to raise_error
      # notice item_number should be invoice
    end

    it "should fail with empty or invalid invoice number" do
      User.stub(:get_most_recent_application).and_return(@mock_app)
      Application.any_instance.stub(:all_forms_completed?).and_return(true)

      # invoice number invalid
      expect { post :verify_payment, {:invoice => "abc123"} }.to raise_error
    end

    it "should fail if application has already been paid" do
      app = FactoryGirl.create(:application)
      app.invoice_number = "abc123"
      app.amount_due = 500
      app.amount_paid = 500
      app.has_paid = true
      app.save!
      User.stub(:get_most_recent_application).and_return(app)
      Application.any_instance.stub(:all_forms_completed?).and_return(true)

      post :verify_payment, {:invoice => "abc123"}
      app.reload
      expect(app.pay_status).to be(0) #nothing changes
    end

    it "should fail if params gross is not the amount actually due" do
      app = FactoryGirl.create(:application)
      app.invoice_number = "abc123"
      app.amount_due = 500
      app.amount_paid = 0
      app.has_paid = false
      app.save!

      User.stub(:get_most_recent_application).and_return(app)
      Application.any_instance.stub(:all_forms_completed?).and_return(true)
      post :verify_payment, {:invoice => "abc123", :mc_gross => 300}
      app.reload
      expect(app.pay_status).to be(0)
      expect(app.has_paid).to be(false)
    end

    it "should fail if paypal cannot verify params" do
      PaymentController.any_instance.stub(:get_paypal_response).and_return("INVALID")
      app = FactoryGirl.create(:application)
      app.invoice_number = "abc123"
      app.amount_due = 500
      app.amount_paid = 0
      app.has_paid = false
      app.save!

      User.stub(:get_most_recent_application).and_return(app)
      Application.any_instance.stub(:all_forms_completed?).and_return(true)
      post :verify_payment, {:invoice => "abc123", :mc_gross => 500}

      app.reload

      expect(app.pay_status).to be(Application::PAYSTATUS_DECLINED)
    end

    it "should succeed if paypal can verify params" do
      PaymentController.any_instance.stub(:get_paypal_response).and_return("VERIFIED")
      app = FactoryGirl.create(:application)
      app.invoice_number = "14304493741"
      app.amount_due = 380.00
      app.amount_paid = 0
      app.has_paid = false
      app.save!

      User.stub(:get_most_recent_application).and_return(app)
      Application.any_instance.stub(:all_forms_completed?).and_return(true)
      post :verify_payment, {:invoice => "14304493741", :mc_gross => "380.00", :txn_id => "abc123", :payment_status => "Pending"}
      app.reload

      expect(app.pay_status).to be(Application::PAYSTATUS_PENDING)
      expect(app.amount_paid).to be == 380.00
      expect(app.has_paid).to be(true)
    end
  end 
end