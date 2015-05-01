class AddAmountDueToApplications < ActiveRecord::Migration
  def change
    add_column :applications, :amount_due, :decimal, default: 0, null: false
  end
end
