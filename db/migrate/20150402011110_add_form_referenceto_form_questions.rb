class AddFormReferencetoFormQuestions < ActiveRecord::Migration
  def change
    add_column :form_questions, :form_id, :integer
    add_index :form_questions, :form_id
  end
end
