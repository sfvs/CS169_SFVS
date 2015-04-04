class CreateForms < ActiveRecord::Migration
  def change
    create_table :forms do |t|
   	  t.string :form_name 
   	  
      t.timestamps
    end
  end
end
