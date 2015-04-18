class AddDescriptionToApplicationTypes < ActiveRecord::Migration
  def change
  	add_column :application_types, :description, :string, null: false, default: ""
  end
end
