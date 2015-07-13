class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :file
      t.integer :attachable_id, index: true
      t.string :attachable_type, index: true

      t.timestamps null: false
    end
  end
end
