FactoryBot.define do
  factory :category do
    name { Faker::Lorem.word }
    id { rand(1..15) }
  end
end
