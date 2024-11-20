FactoryBot.define do
  factory :post do
    content { Faker::Lorem.paragraph(sentence_count: 4) }
    access_info { Faker::Lorem.sentence(word_count: 6) }
    association :user
    association :spot
  end
end
