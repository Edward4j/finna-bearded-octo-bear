class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :body
      t.references :commentable, polymorphic: true, index: true
      t.integer :user_id

      t.timestamp
    end

    add_index :comments, :user_id
  end
end
