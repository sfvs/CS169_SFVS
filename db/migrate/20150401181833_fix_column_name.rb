class FixColumnName < ActiveRecord::Migration
  def up
    rename_column :forms, :app_name, :form_name
  end

  def down
  end
end
