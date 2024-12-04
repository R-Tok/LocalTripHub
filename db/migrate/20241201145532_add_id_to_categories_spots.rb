class AddIdToCategoriesSpots < ActiveRecord::Migration[7.2]
  def change
    add_column :categories_spots, :id, :primary_key
  end
end
