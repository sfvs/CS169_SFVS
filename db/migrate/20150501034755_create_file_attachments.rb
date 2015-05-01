class CreateFileAttachments < ActiveRecord::Migration
  def change
    create_table :file_attachments do |t|
      t.column :filename, :string
      t.column :content_type, :string
      t.column :data, :binary
      t.column :file_type, :string
      t.belongs_to :applications, index:true

      t.timestamps
    end
  end
end
