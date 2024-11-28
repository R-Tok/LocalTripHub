class Municipality < ApplicationRecord
  belongs_to :prefecture
  has_many :spots

  def self.ransackable_attributes(auth_object = nil)
    [ "id", "name", "prefecture_id" ]
  end
end
