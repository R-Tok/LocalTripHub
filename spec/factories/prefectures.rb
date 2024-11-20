FactoryBot.define do
  factory :prefecture do
    name { Faker::Address.state }
    sequence(:id) { |n| n }
  end
end
