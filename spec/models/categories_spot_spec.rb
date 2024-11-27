require "rails_helper"

RSpec.describe CategoriesSpot, type: :model do
  context "CategoriesSpotバリデーション" do
    let!(:prefecture) { Prefecture.find_by(id: 1) || create(:prefecture, id: 1, name: "北海道") }
    let!(:municipality) { Municipality.find_by(id: 1) || create(:Municipality, id: 1, name: "札幌市中央区") }
    let(:spot) { create(:spot, prefecture: prefecture, municipality: municipality) }
    let(:category) { create(:category) }

    it "spot_idとcategory_idの組み合わせがユニークであること" do
      create(:categories_spot, spot: spot, category: category)
      duplicate = build(:categories_spot, spot: spot, category: category)
      expect(duplicate).to be_invalid
      expect(duplicate.errors[:spot_id]).to include("はすでに存在します")
    end

    # it "spot_idが存在しない場合は無効であること" do
    #   invalid = build(:categories_spot, spot: nil, category: category)
    #   expect(invalid).to be_invalid
    #   expect(invalid.errors[:spot_id]).to include("を入力してください")
    # end

    it "category_idが存在しない場合は無効であること" do
      invalid = build(:categories_spot, spot: spot, category: nil)
      expect(invalid).to be_invalid
      expect(invalid.errors[:category_id]).to include("を入力してください")
    end
  end
end
