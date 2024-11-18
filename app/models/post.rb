class Post < ApplicationRecord
  validates :content, presence: true, length: { maximum: 65535 }
  validates :access_info, length: { maximum: 65535 }

  belongs_to :user
  belongs_to :spot
  has_many :images, dependent: :destroy
  accepts_nested_attributes_for :images, allow_destroy: true
  has_many :bookmarks, dependent: :destroy
  has_many :lists, through: :bookmarks
end
