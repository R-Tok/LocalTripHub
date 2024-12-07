class ChangeImageToBeNullable < ActiveRecord::Migration[7.2]
  def change
    change_column_null :images, :post_id, true
  end
end
