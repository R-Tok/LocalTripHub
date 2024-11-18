class CreateBookmarks < ActiveRecord::Migration[7.2]
  def change
    create_table :bookmarks do |t|
      t.references :list, foreign_key: true, null: false
      t.references :post, foreign_key: true, null: false

      t.timestamps
    end
    add_index :bookmarks, [ :list_id, :post_id ], unique: true
  end
end
