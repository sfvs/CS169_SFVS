class CreateApplications < ActiveRecord::Migration
  def change
    create_table :applications do |t|
	  t.belongs_to :user, index:true
      t.integer :year
      t.string :type
      t.string :content
      t.boolean :completed, null: false, default: false
      t.timestamps
    end
  end
end
