class CreateApplications < ActiveRecord::Migration
  def change
    create_table :applications do |t|
	  t.belongs_to :user, index:true
      t.integer :year
      t.string :status
      t.json :content
      t.timestamps
    end
  end
end
