FactoryBot.define do
  factory :list do
    name { Faker::Lorem.word }
    caption { Faker::Lorem.sentence }
    association :user
  end
end
