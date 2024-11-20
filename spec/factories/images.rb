FactoryBot.define do
  factory :image do
    image_url { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/sample_image.jpg'), 'image/jpeg') }
    association :post
  end
end
