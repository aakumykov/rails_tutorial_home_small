class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :reader_id
      t.integer :author_id

      t.timestamps
    end
  end
end
