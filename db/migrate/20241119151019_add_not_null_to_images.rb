class AddNotNullToImages < ActiveRecord::Migration[7.2]
  def change
    change_column_null :images, :image_url, false
    change_column_null :posts, :user_id, false
    change_column_null :posts, :spot_id, false
    change_column_null :spots, :user_id, false
  end
end
