require "rails_helper"

RSpec.describe Image, type: :model do
  context "Imageバリデーション" do
    let(:image) { create(:image) }

    it "post_idが必須であること" do
      image.post_id = nil
      expect(image).to be_invalid
    end

    it "image_urlが必須であること" do
      image.image_url = nil
      expect(image).to be_invalid
    end
  end
end
