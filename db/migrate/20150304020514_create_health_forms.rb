class CreateHealthForms < ActiveRecord::Migration
  def change
    create_table :health_forms do |t|
	  t.belongs_to :application, index:true
      t.timestamps
    end
  end
end
