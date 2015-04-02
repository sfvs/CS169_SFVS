class AddApplicationNameToForms < ActiveRecord::Migration
  def change
    add_column :forms, :app_name, :string
  end
end
