class CreateLists < ActiveRecord::Migration[7.2]
  def change
    create_table :lists do |t|
      t.string :name, null: false
      t.string :caption
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
