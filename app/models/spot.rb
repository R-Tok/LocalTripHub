class Spot < ApplicationRecord
  validates :name, presence: true, length: { maximum: 255 }
  validates :latitude, presence: true, numericality: { greater_than_or_equal_to: 20.4, less_than_or_equal_to: 45.6 }
  validates :longitude, presence: true, numericality: { greater_than_or_equal_to: 122.9, less_than_or_equal_to: 154.0 }
  validates :user_id, presence: true
  validates :prefecture_id, presence: true, inclusion: { in: 1..47, message: "は1から47の範囲内で指定してください" }
  validates :municipality_id, presence: true, inclusion: { in: 1..1892, message: "は1から1892の範囲内で指定してください" }

  validate :latitude_precision
  validate :longitude_precision

  belongs_to :user
  belongs_to :prefecture
  belongs_to :municipality
  has_many :posts, dependent: :destroy

  has_many :categories_spots
  has_many :categories, through: :categories_spots

  def self.ransackable_attributes(auth_object = nil)
    [ "id", "id_value", "municipality_id", "name", "prefecture_id" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "prefecture", "municipality", "posts" ]
  end

  private

  def latitude_precision
    unless valid_decimal?(latitude)
      errors.add(:latitude, "は小数点以下6桁までの数値で入力してください")
    end
  end

  def longitude_precision
    unless valid_decimal?(longitude)
      errors.add(:longitude, "は小数点以下6桁までの数値で入力してください")
    end
  end

  def valid_decimal?(value)
    return false unless value.is_a?(Numeric)
    value.to_s.match?(/\A-?\d+(\.\d{1,6})?\z/)
  end
end
