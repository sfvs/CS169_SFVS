class Payment < ActiveRecord::Base
  attr_accessible :amount_paid, :amount_due, :has_paid, :pay_receipt, :pay_status, :invoice_number, :txn_id
  belongs_to :application
end
