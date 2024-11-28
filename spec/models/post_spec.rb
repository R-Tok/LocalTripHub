require "rails_helper"

RSpec.describe Post, type: :model do
  context "Postバリデーション" do
    let!(:prefecture) { Prefecture.find_by(id: 1) || create(:prefecture, id: 1, name: "北海道") }
    let!(:municipality) { Municipality.find_by(id: 1) || create(:Municipality, id: 1, name: "札幌市中央区") }
    let(:spot) { create(:spot, prefecture: prefecture, municipality: municipality) }
    let(:post) { create(:post, spot: spot) }

    it "本文・アクセス情報が正しければ登録できる" do
      expect(post).to be_valid
    end

    it "本文が必須であること" do
      post.content = nil
      expect(post).to be_invalid
      expect(post.errors[:content]).to include("を入力してください")
    end

    it "本文が65535文字以内であること" do
      post.content = "a" * 65536
      expect(post).to be_invalid
      expect(post.errors[:content]).to include("は65535文字以内で入力してください")
    end

    it "アクセス・営業時間が65535文字以内であること" do
      post.access_info = "a" * 65536
      expect(post).to be_invalid
      expect(post.errors[:access_info]).to include("は65535文字以内で入力してください")
    end

    it "ユーザーidが必須であること" do
      post.user_id = nil
      expect(post).to be_invalid
    end

    it "spot_idが必須であること" do
      post.spot_id = nil
      expect(post).to be_invalid
    end

    it "画像が10枚以内なら有効であること" do
      10.times { post.images.build(image_url: Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/sample_image.jpg'), 'image/jpeg')) }
      expect(post).to be_valid
    end

    it "画像が11枚以上なら無効であること" do
      11.times { post.images.build(image_url: Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/sample_image.jpg'), 'image/jpeg')) }
      expect(post).to be_invalid
      expect(post.errors[:images]).to include("は10枚までしか登録できません")
    end
  end
end
