FactoryBot.define do
  factory :contact do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    subject { Faker::Lorem.sentence(word_count: 3) }
    message { Faker::Lorem.paragraph }
  end
end
