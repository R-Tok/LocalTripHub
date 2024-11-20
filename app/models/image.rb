class Image < ApplicationRecord
  belongs_to :post

  mount_uploader :image_url, PostImageUploader

  validates :image_url, presence: true
  validates :post_id, presence: true
end
