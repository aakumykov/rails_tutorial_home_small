class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :reader_id
      t.integer :author_id

      t.timestamps
    end
    add_index :relationships, :reader_id
    add_index :relationships, :author_id
    add_index :relationships, [:reader_id, :author_id], unique: true
  end
end
