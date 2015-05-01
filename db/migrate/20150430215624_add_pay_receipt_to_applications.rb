class AddPayReceiptToApplications < ActiveRecord::Migration
  def change
    add_column :applications, :pay_receipt, :text, default: "", null: false
  end
end
