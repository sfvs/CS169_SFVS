class AddInvoiceNumberToApplications < ActiveRecord::Migration
  def change
    add_column :applications, :invoice_number, :string, default: "", null: false
  end
end
