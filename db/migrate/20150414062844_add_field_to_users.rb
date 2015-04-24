class AddFieldToUsers < ActiveRecord::Migration
  def change
    add_column :users, :contact_person, :string, null: false, default: ""
    add_column :users, :company_name, :string, null: false, default: ""
    add_column :users, :telephone, :string, null: false, default: ""
  end
end
