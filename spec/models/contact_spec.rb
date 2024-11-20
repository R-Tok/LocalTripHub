require "rails_helper"

RSpec.describe Contact, type: :model do
  context "Contactバリデーション" do
    let(:contact) { create(:contact) }

    it "名前・email・件名・本文が正しければ登録できる" do
      expect(contact).to be_valid
    end

    it "名前が必須であること" do
      contact.name = nil
      expect(contact).to be_invalid
      expect(contact.errors[:name]).to include("を入力してください")
    end

    it "名前は255文字以内であること" do
      contact.name = "a" * 256
      expect(contact).to be_invalid
      expect(contact.errors[:name]).to include("は255文字以内で入力してください")
    end

    it "emailが必須であること" do
      contact.email = nil
      expect(contact).to be_invalid
      expect(contact.errors[:email]).to include("を入力してください")
    end

    it "件名が必須であること" do
      contact.subject = nil
      expect(contact).to be_invalid
      expect(contact.errors[:subject]).to include("を入力してください")
    end

    it "件名は255文字以内であること" do
      contact.subject = "a" * 256
      expect(contact).to be_invalid
      expect(contact.errors[:subject]).to include("は255文字以内で入力してください")
    end

    it "メッセージ本文が必須であること" do
      contact.message = nil
      expect(contact).to be_invalid
      expect(contact.errors[:message]).to include("を入力してください")
    end

    it "メッセージ本文は65535文字以内であること" do
      contact.message = "a" * 65536
      expect(contact).to be_invalid
      expect(contact.errors[:message]).to include("は65535文字以内で入力してください")
    end
  end
end
