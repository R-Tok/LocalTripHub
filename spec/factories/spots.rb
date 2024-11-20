FactoryBot.define do
  factory :spot do
    name { Faker::Address.unique.community }
    latitude { rand(20.4..45.6) }
    longitude { rand(122.9..154.0) }
    association :user
    association :prefecture
    association :municipality
  end
end
