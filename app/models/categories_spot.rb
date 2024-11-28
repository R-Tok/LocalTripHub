class CategoriesSpot < ApplicationRecord
  validates :spot_id, uniqueness: { scope: :category_id }
  validates :category_id, presence: true

  belongs_to :spot, optional: true
  belongs_to :category, optional: true
end
