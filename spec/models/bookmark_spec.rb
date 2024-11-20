require "rails_helper"

RSpec.describe Bookmark, type: :model do
  context "Bookmarkバリデーション" do
    let(:bookmark1) { create(:bookmark) }
    let(:bookmark2) { create(:bookmark) }

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
