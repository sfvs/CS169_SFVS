class AddHasPaidToApplication < ActiveRecord::Migration
  def change
    add_column :applications, :has_paid, :boolean, default: false, null: false
  end
end
