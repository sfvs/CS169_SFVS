class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
	  add_column :users, :username, :string
	  add_column :users, :password, :string
      t.timestamps
    end
  end
end
