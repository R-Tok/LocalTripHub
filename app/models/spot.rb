class Spot < ApplicationRecord
  validates :name, presence: true, length: { maximum: 255 }
  validates :latitude, presence: true
  validates :longitude, presence: true

  belongs_to :user
  belongs_to :prefecture
  belongs_to :municipality
  has_many :posts, dependent: :destroy

  has_and_belongs_to_many :categories
end
