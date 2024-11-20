class Post < ApplicationRecord
  validates :content, presence: true, length: { maximum: 65535 }
  validates :access_info, length: { maximum: 65535 }
  validate :images_upto_10

  belongs_to :user
  belongs_to :spot
  has_many :images, dependent: :destroy
  accepts_nested_attributes_for :images, allow_destroy: true, reject_if: proc { |attributes| attributes["image_url"].blank? }
  has_many :bookmarks, dependent: :destroy
  has_many :lists, through: :bookmarks

  private

  def images_upto_10
    if images.size > 10
      errors.add(:images, "は10枚までしか登録できません")
    end
  end
end
