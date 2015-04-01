class CreateFormQuestions < ActiveRecord::Migration
  def change
    create_table :form_questions do |t|

      t.string :question 
      t.string :app_type
      t.string :question_type
      t.integer :order
      t.timestamps
    end
  end
end
