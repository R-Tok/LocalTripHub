require "rails_helper"

RSpec.describe List, type: :model do
  context "Listバリデーション" do
    let(:list) { create(:list) }

    it "リスト名・キャプションが正しければ登録できる" do
      expect(list).to be_valid
    end

    it "リスト名が必須であること" do
      list.name = nil
      expect(list).to be_invalid
      expect(list.errors[:name]).to include("を入力してください")
    end

    it "リスト名は255文字以下であること" do
      list.name = "a" * 256
      expect(list).to be_invalid
      expect(list.errors[:name]).to include("は255文字以内で入力してください")
    end

    it "キャプションは255文字以下であること" do
      list.caption = "a" * 256
      expect(list).to be_invalid
      expect(list.errors[:caption]).to include("は255文字以内で入力してください")
    end

    it "user_idが必須であること" do
      list.user_id = nil
      expect(list).to be_invalid
    end
  end
end
