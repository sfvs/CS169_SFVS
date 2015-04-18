class AddAmountPaidToApplications < ActiveRecord::Migration
  def change
    add_column :applications, :amount_paid, :decimal, default: 0
  end
end
