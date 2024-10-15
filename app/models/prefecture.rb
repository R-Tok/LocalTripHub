class Prefecture < ApplicationRecord
  has_many :municipalities
  has_many :spots
end
