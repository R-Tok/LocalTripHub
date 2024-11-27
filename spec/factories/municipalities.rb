FactoryBot.define do
  factory :municipality do
    name { Faker::Address.city }
    association :prefecture
  end
end
