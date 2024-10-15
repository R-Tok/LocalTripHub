class CreateMunicipalities < ActiveRecord::Migration[7.2]
  def change
    create_table :municipalities do |t|
      t.references :prefecture, foreign_key: true, null: false
      t.string :name, null: false

      t.timestamps
    end
  end
end
