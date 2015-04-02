class AddApplicationReferenceToForms < ActiveRecord::Migration
  def change
    add_column :forms, :application_id, :integer
    add_index :forms, :application_id
  end
end
