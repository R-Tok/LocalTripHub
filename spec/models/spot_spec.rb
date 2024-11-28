require "rails_helper"

RSpec.describe Spot, type: :model do
  context "Spotバリデーション" do
    let!(:prefecture) { Prefecture.find_by(id: 1) || create(:prefecture, id: 1, name: "北海道") }
    let!(:municipality) { Municipality.find_by(id: 1) || create(:Municipality, id: 1, name: "札幌市中央区") }
    let(:spot) { create(:spot, prefecture: prefecture, municipality: municipality) }

    it "スポット名・緯度・経度・都道府県・市区町村が正しければ登録できること" do
      expect(spot).to be_valid
    end

    it "スポット名が必須であること" do
      spot.name = nil
      expect(spot).to be_invalid
      expect(spot.errors[:name]).to include("を入力してください")
    end

    it "スポット名が256文字以上でエラーになること" do
      spot.name = "a" * 256
      expect(spot).to be_invalid
      expect(spot.errors[:name]).to include("は255文字以内で入力してください")
    end

    it "緯度が必須であること" do
      spot.latitude = nil
      expect(spot).to be_invalid
      expect(spot.errors[:latitude]).to include("を入力してください")
    end

    it "緯度が文字列でなく数字であること" do
      spot.latitude = "abc"
      expect(spot).to be_invalid
      expect(spot.errors[:latitude]).to include("は数値で入力してください")
    end

    it "緯度が小数点6桁の数値で正しく丸められていること" do
      spot.latitude = 40.123456789
      expect(spot).to be_valid
      expect(spot.latitude).to be_within(0.0000005).of(40.123456789)
    end

    it "緯度が20.4以上であること" do
      spot.latitude = 20.3999994
      expect(spot).to be_invalid
      expect(spot.errors[:latitude]).to include("は20.4以上の値にしてください")
    end

    it "緯度が45.6以下であること" do
      spot.latitude = 45.6000005
      expect(spot).to be_invalid
      expect(spot.errors[:latitude]).to include("は45.6以下の値にしてください")
    end

    it "経度が必須であること" do
      spot.longitude = nil
      expect(spot).to be_invalid
      expect(spot.errors[:longitude]).to include("を入力してください")
    end

    it "経度が文字列でなく数字であること" do
      spot.longitude = "abc"
      expect(spot).to be_invalid
      expect(spot.errors[:longitude]).to include("は数値で入力してください")
    end

    it "経度が10桁、小数点6桁の数値であること" do
      spot.longitude = 140.123456789
      expect(spot).to be_valid
      expect(spot.longitude).to be_within(0.0000005).of(140.123456789)
    end

    it "経度が122.9以上であること" do
      spot.longitude = 122.8999994
      expect(spot).to be_invalid
      expect(spot.errors[:longitude]).to include("は122.9以上の値にしてください")
    end

    it "経度が154.0以下であること" do
      spot.longitude = 154.0000005
      expect(spot).to be_invalid
      expect(spot.errors[:longitude]).to include("は154.0以下の値にしてください")
    end

    it "登録ユーザーidが必須であること" do
      spot.user_id = nil
      expect(spot).to be_invalid
      expect(spot.errors[:user_id]).to include("を入力してください")
    end

    it "都道府県idが必須であること" do
      spot.prefecture_id = nil
      expect(spot).to be_invalid
      expect(spot.errors[:prefecture_id]).to include("を入力してください")
    end

    it "都道府県idは1~47の範囲内であること" do
      spot.prefecture_id = 48
      expect(spot).to be_invalid
      expect(spot.errors[:prefecture_id]).to include("は1から47の範囲内で指定してください")
    end

    it "市区町村idが必須であること" do
      spot.municipality_id = nil
      expect(spot).to be_invalid
      expect(spot.errors[:municipality_id]).to include("を入力してください")
    end

    it "市区町村idは1~1892の範囲内であること" do
      spot.municipality_id = 1893
      expect(spot).to be_invalid
      expect(spot.errors[:municipality_id]).to include("は1から1892の範囲内で指定してください")
    end
  end
end
