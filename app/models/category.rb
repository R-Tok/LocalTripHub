class Category < ApplicationRecord
  has_many :categories_spots
  has_many :spots, through: :categories_spots
end
