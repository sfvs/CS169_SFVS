class AddPaymentInformationToApplications < ActiveRecord::Migration
  def change
    add_column :applications, :amount_paid, :decimal, default: 0
    add_column :applications, :has_paid, :boolean, default: false
  end
end
