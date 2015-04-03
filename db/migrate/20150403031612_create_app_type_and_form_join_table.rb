class CreateAppTypeAndFormJoinTable < ActiveRecord::Migration
  def change
    create_table :app_types_forms, id: false do |t|
      t.belongs_to :application_type, index: true
      t.belongs_to :form, index: true
    end
  end
end
