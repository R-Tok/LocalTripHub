class List < ApplicationRecord
  validates :name, presence: true, length: { maximum: 255 }

  belongs_to :user
  has_many :bookmarks, dependent: :destroy
  has_many :posts, through: :bookmarks
  has_many :listed_posts, through: :bookmark, source: :post

  def bookmark(post)
    listed_posts << list
  end

  def unbookmark(post)
    listed_posts.destroy(post)
  end

  def bookmark?(post)
    listed_posts.include?(post)
  end
end
