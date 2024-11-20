FactoryBot.define do
  factory :categories_spot do
    association :spot
    association :category
  end
end
