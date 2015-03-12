class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.text :ans
      t.integer :leads_to
      t.belongs_to :questionnaire, index:true

      t.timestamps
    end
  end
end