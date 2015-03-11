class CreateQuestionnaires < ActiveRecord::Migration
  def change
    create_table :questionnaires do |t|
      t.text :question
      t.integer :parent_id

      t.timestamps
    end
  end
end
