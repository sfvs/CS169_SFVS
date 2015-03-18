class CreateFormQuestions < ActiveRecord::Migration
  def change
    create_table :form_questions do |t|

      t.string :question 
      t.string :form_type
      t.string :question_type
      t.integer :order
      t.boolean :completed, null: false, default: false
      t.timestamps
    end
  end
end
