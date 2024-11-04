class AddIndexToMunicipalities < ActiveRecord::Migration[7.2]
  def change
    add_index :municipalities, :name
  end
end
