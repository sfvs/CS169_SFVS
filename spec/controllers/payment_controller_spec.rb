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

      #expect { post :verify_payment, {:item_number => "abc123"} }.to raise_error
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
      #raw_query = "mc_gross=380.00&invoice=14304493741&protection_eligibility=Ineligible&address_status=confirmed&payer_id=7RTK29EQXKAU6&tax=0.00&address_street=1+Main+St&payment_date=20%3A05%3A34+Apr+30%2C+2015+PDT&payment_status=Pending&charset=windows-1252&address_zip=95131&first_name=test&address_country_code=US&address_name=test+buyer&notify_version=3.8&custom=&payer_status=verified&address_country=United+States&address_city=San+Jose&quantity=1&verify_sign=A0W3PHNbCM.v5Sv7AarFHkovUSzRAzf4QEuJ8..JaPB8U7WSRbQG0rw1&payer_email=teamsfvs-buyer%40gmail.com&txn_id=4CE52036EV1277053&payment_type=instant&last_name=buyer&address_state=CA&receiver_email=sfvsteam-business%40gmail.com&pending_reason=unilateral&txn_type=web_accept&item_name=SFVS+Registration+Fee&mc_currency=USD&item_number=14304493741&residence_country=US&test_ipn=1&handling_amount=0.00&transaction_subject=&payment_gross=380.00&shipping=0.00&ipn_track_id=a3639521b67b5"
      #raw_post(:verify_payment, Rack::Utils.parse_nested_query(raw_query), raw_query)
      post :verify_payment, {:invoice => "14304493741", :mc_gross => "380.00", :txn_id => "abc123", :payment_status => "Pending"}
      app.reload

      expect(app.pay_status).to be(Application::PAYSTATUS_PENDING)
      expect(app.amount_paid).should == 380.00
      expect(app.has_paid).to be(true)
    end

    def raw_post(action, params, body)
      @request.env['RAW_POST_DATA'] = body
      response = post(action, params)
      @request.env.delete('RAW_POST_DATA')
      response
    end
  end 
end