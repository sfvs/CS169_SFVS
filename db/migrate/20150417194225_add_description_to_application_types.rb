class AddDescriptionToApplicationTypes < ActiveRecord::Migration
  def change
  	add_column :application_types, :description, :text, null: false, default: ""
  end
end
