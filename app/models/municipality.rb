class Municipality < ApplicationRecord
  belongs_to :prefecture
  has_many :spots
end
