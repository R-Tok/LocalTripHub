class Post < ApplicationRecord
  validates :content, presence: true, length: { maximum: 65535 }
  validates :access_info, presence: true, length: { maximum: 65535 }

  belongs_to :user
  belongs_to :spot
end
