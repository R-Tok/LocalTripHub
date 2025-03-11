require "rails_helper"

# bundle exec rspec ./spec/models/user_spec.rb で実行
RSpec.describe User, type: :model do
  context "Userバリデーション" do
    let(:user) { build(:user) }

    it "ニックネーム・アドレス・パスワードが正しければ登録できる" do
      expect(user).to be_valid
    end

    it "nicknameが必須であること" do
      user.nickname = nil
      expect(user).to be_invalid
      expect(user.errors[:nickname]).to include("を入力してください")
    end

    it "nicknameは255文字以下であること" do
      user.nickname = "a" * 255
      expect(user).to be_valid
    end

    it "nicknameは256文字以上で無効であること" do
      user.nickname = "a" * 256
      expect(user).to be_invalid
      expect(user.errors[:nickname]).to include("は255文字以内で入力してください")
    end

    it "パスワード確認が必須であること" do
      user.password_confirmation = nil
      expect(user).to be_invalid
      expect(user.errors[:password_confirmation]).to include("を入力してください")
    end

    it "パスワードが5文字以下で無効であること" do
      user.password = "short"
      expect(user).to be_invalid
      expect(user.errors[:password]).to include("は6文字以上で入力してください")
    end

    it "パスワードが6文字以上であること" do
      user.password = "length"
      user.password_confirmation = "length"
      expect(user).to be_valid
    end

    it "パスワードとパスワード確認が一致すること" do
      user.password = "password"
      user.password_confirmation = "password_different"
      expect(user).to be_invalid
      expect(user.errors[:password_confirmation]).to include("とパスワードの入力が一致しません")
    end

    # it "メールアドレスが必須であること" do
    #   user.email = nil
    #   expect(user).to be_invalid
    #   expect(user.errors[:email]).to include("を入力してください")
    # end
    it "メールアドレスが一意であること" do
      create(:user, email: "test@example.com")
      user.email = "test@example.com"
      expect(user).to be_invalid
      expect(user.errors[:email]).to include("はすでに存在します")
    end

    it "自己紹介は5001文字以上だとエラーであること" do
      user.introduction = "a" * 5001
      expect(user).to be_invalid
      expect(user.errors[:introduction]).to include("は5000文字以内で入力してください")
    end

    it "自己紹介は5000文字以下なら有効であること" do
      user.introduction = "a" * 5000
      expect(user).to be_valid
    end
  end
end
