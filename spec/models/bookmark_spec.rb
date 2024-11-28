require "rails_helper"

RSpec.describe Bookmark, type: :model do
  context "Bookmarkバリデーション" do
    let!(:prefecture) { Prefecture.find_by(id: 1) || create(:prefecture, id: 1, name: "北海道") }
    let!(:municipality) { Municipality.find_by(id: 1) || create(:Municipality, id: 1, name: "札幌市中央区") }
    let(:spot) { create(:spot, prefecture: prefecture, municipality: municipality) }
    let(:post) { create(:post, spot: spot) }
    let(:list1) { create(:list) }
    let(:list2) { create(:list) }
    let(:bookmark1) { create(:bookmark, list: list1, post: post) }
    let(:bookmark2) { create(:bookmark, list: list2, post: post) }

    it "post_idが必須であること" do
      bookmark1.post_id = nil
      expect(bookmark1).to be_invalid
    end

    it "list_idが必須であること" do
      bookmark1.list_id = nil
      expect(bookmark1).to be_invalid
    end

    it "list_idに対してpost_idが一意であること" do
      bookmark2.list_id = bookmark1.list_id
      bookmark2.post_id = bookmark1.post_id
      expect(bookmark2).to be_invalid
    end
  end
end
