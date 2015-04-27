class CreateApplications < ActiveRecord::Migration
  def change
    create_table :applications do |t|
	    t.belongs_to :user, index:true
      t.belongs_to :application_type, index:true
      t.integer :year
      t.text :content, null: false, default: ""
      t.boolean :completed, null: false, default: false
      t.boolean :approved, null: false, default: false
      t.timestamps
    end
  end
end
