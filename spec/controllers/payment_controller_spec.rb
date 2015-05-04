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
      # invoice number invalid
      expect { post :verify_payment, {:invoice => "abc123"} }.to raise_error
    end

    it "should fail if application has already been paid" do
      payment = FactoryGirl.create(:payment)
      payment.invoice_number = "abc123"
      payment.amount_due = 500
      payment.amount_paid = 500
      payment.has_paid = true
      payment.save!

      post :verify_payment, {:invoice => "abc123"}
      payment.reload
      expect(payment.pay_status).to be(0) #nothing changes
    end

    it "should fail if params gross is not the amount actually due" do
      payment = FactoryGirl.create(:payment)
      payment.invoice_number = "abc123"
      payment.amount_due = 500
      payment.amount_paid = 0
      payment.has_paid = false
      payment.save!

      post :verify_payment, {:invoice => "abc123", :mc_gross => 300}
      payment.reload
      expect(payment.pay_status).to be(0)
      expect(payment.has_paid).to be(false)
    end

    it "should fail if paypal cannot verify params" do
      PaymentController.any_instance.stub(:get_paypal_response).and_return("INVALID")
      payment = FactoryGirl.create(:payment)
      payment.invoice_number = "abc123"
      payment.amount_due = 500
      payment.amount_paid = 0
      payment.has_paid = false
      payment.save!

      post :verify_payment, {:invoice => "abc123", :mc_gross => 500}
      payment.reload

      expect(payment.pay_status).to be(Payment::PAYSTATUS_DECLINED)
    end

    it "should succeed if paypal can verify params" do
      PaymentController.any_instance.stub(:get_paypal_response).and_return("VERIFIED")
      payment = FactoryGirl.create(:payment)
      payment.invoice_number = "14304493741"
      payment.amount_due = 380.00
      payment.amount_paid = 0
      payment.has_paid = false
      payment.save!

      post :verify_payment, {:invoice => "14304493741", :mc_gross => "380.00", :txn_id => "abc123", :payment_status => "Pending"}
      payment.reload

      expect(payment.pay_status).to be(Payment::PAYSTATUS_PENDING)
      expect(payment.amount_paid).to be == 380.00
      expect(payment.has_paid).to be(true)
    end
  end 
end