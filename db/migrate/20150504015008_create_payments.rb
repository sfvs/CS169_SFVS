class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.string :invoice_number, default: "", null: false
      t.integer :pay_status, default: 0, null: false
      t.text :pay_receipt, default: "", null: false
      t.decimal :amount_due, default: 0, null: false
      t.boolean :has_paid, default: false, null: false
      t.string :txn_id, default: "", null: false
      t.decimal :amount_paid, default: 0
      t.belongs_to :application, index:true

      t.timestamps
    end
  end
end
