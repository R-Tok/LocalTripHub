class CreateJoinTableSpotCategory < ActiveRecord::Migration[7.2]
  def change
    create_join_table :spots, :categories do |t|
      # t.index [:spot_id, :category_id]
      # t.index [:category_id, :spot_id]
    end
  end
end
