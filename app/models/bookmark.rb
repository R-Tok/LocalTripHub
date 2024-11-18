class Bookmark < ApplicationRecord
  belongs_to :post
  belongs_to :list

  validates :list_id, uniqueness: { scope: :post_id }
end
