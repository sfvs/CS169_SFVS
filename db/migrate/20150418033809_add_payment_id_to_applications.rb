class AddPaymentIdToApplications < ActiveRecord::Migration
  def change
    add_column :applications, :payment_id, :string
  end
end
