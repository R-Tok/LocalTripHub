require "rails_helper"

RSpec.describe Image, type: :model do
  context "Imageバリデーション" do
    let!(:prefecture) { Prefecture.find_by(id: 1) || create(:prefecture, id: 1, name: "北海道") }
    let!(:municipality) { Municipality.find_by(id: 1) || create(:Municipality, id: 1, name: "札幌市中央区") }
    let(:spot) { create(:spot, prefecture: prefecture, municipality: municipality) }
    let(:post) { create(:post, spot: spot) }
    let(:image) { create(:image, post: post) }

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
