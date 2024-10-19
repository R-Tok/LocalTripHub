class Post < ApplicationRecord
  validates :content, presence: true, length: { maximum: 65535 }
  validates :access_info, presence: true, length: { maximum: 65535 }

  belongs_to :user
  belongs_to :spot
  has_many :images, dependent: :destroy
  accepts_nested_attributes_for :images, allow_destroy: true
end
