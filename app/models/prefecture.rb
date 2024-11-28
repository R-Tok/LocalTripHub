class Prefecture < ApplicationRecord
  has_many :municipalities
  has_many :spots

  def self.ransackable_attributes(auth_object = nil)
    [ "id", "name" ]
  end
end
