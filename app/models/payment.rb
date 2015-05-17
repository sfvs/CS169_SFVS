class Payment < ActiveRecord::Base
  attr_accessible :amount_paid, :amount_due, :has_paid, :pay_receipt, :pay_status, :invoice_number, :txn_id
  belongs_to :application

  PAYSTATUS_UNPAID = 0
  PAYSTATUS_PENDING = 1
  PAYSTATUS_PAID = 2
  PAYSTATUS_DECLINED = 3
  PAYSTATUS_CHECK = 4

  def method_missing(method_id, *args)
    name = method_id.to_s
    if name =~ /pay_status_long$/
      self.send(:status_description, @@status_strings_long)
    elsif name =~ /pay_status_short$/
      self.send(:status_description, @@status_strings_short)
    else
      super
    end
  end

  def status_description conversion
    conversion[self.pay_status]
  end

  private

  @@status_strings_long = {
    PAYSTATUS_UNPAID => "Not Paid",
    PAYSTATUS_PENDING => "Pending", 
    PAYSTATUS_PAID => "Payment received! Thank you!",
    PAYSTATUS_DECLINED => "An error occurred while processing your payment. While your application is submitted, you will need to contact support to submit payment.",
    PAYSTATUS_CHECK => "Payment received via check! Thank you!"
  }

  @@status_strings_short = {
    PAYSTATUS_UNPAID =>"Not Paid",
    PAYSTATUS_PENDING => "Pending",
    PAYSTATUS_PAID => "Paid",
    PAYSTATUS_DECLINED => "Declined",
    PAYSTATUS_CHECK => "Paid via check"
  }

end
