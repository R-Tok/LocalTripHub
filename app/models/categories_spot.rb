class CategoriesSpot < ApplicationRecord
  validates :spot_id, presence: true, uniqueness: { scope: :category_id }
  validates :category_id, presence: true

  belongs_to :spot
  belongs_to :category
end
