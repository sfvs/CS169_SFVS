class CreateFileAttachments < ActiveRecord::Migration
  def change
    create_table :file_attachments do |t|

      t.column :filename, :string
      t.column :content_type, :string
      t.column :data, :binary, :limit => 5.megabyte
      t.column :file_type, :string
      t.belongs_to :application, index:true

      t.timestamps
    end
  end
end
