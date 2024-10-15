class AddPrefectureAndMunicipalityToSpots < ActiveRecord::Migration[7.2]
  def change
    add_reference :spots, :prefecture, null: false, foreign_key: true
    add_reference :spots, :municipality, null: false, foreign_key: true
  end
end
