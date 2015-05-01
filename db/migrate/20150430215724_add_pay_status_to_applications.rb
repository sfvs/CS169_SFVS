class AddPayStatusToApplications < ActiveRecord::Migration
  def change
    add_column :applications, :pay_status, :integer, default: 0, null: false
  end
end
