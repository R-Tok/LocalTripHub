FactoryBot.define do
  factory :bookmark do
    association :list
    association :post
  end
end
