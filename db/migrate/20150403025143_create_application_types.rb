class CreateApplicationTypes < ActiveRecord::Migration
  def change
    create_table :application_types do |t|

      t.string :app_type
      t.timestamps
    end
  end
end
