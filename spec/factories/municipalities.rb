FactoryBot.define do
  factory :municipality do
    name { Faker::Address.city }
    association :prefecture
    id { rand(1..1892) }
  end
end
