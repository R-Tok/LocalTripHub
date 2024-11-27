require 'rails_helper'

RSpec.describe "Users", type: :system, js: true do
  before do
    driven_by(:rack_test)
    visit new_user_path
  end

  describe "User#new" do
    context "ログイン前にユーザー新規登録画面にアクセス" do
      it "フォームの内容が正常なら登録成功 => ログイン状態でトップ画面へ遷移" do
        fill_in "ニックネーム", with: "テストユーザー"
        fill_in "メールアドレス", with: "test@sample.com"
        fill_in "パスワード", with: "password"
        fill_in "パスワード確認", with: "password"
        click_button "登録"

        expect(page).to have_content("ユーザー登録に成功しました")
        expect(page).to have_content("テストユーザー")
        expect(current_path).to eq root_path
      end

      it "ニックネームが空欄のとき登録に失敗" do
        fill_in "ニックネーム", with: ""
        fill_in "メールアドレス", with: "test@sample.com"
        fill_in "パスワード", with: "password"
        fill_in "パスワード確認", with: "password"
        click_button "登録"

        expect(page).to have_content("ユーザー登録に失敗しました")
        expect(page).to have_content("ニックネームを入力してください")
        expect(page).to have_current_path("/users")
      end

      it "メールアドレスが空欄のとき登録に失敗" do
        fill_in "ニックネーム", with: "テストユーザー"
        fill_in "メールアドレス", with: ""
        fill_in "パスワード", with: "password"
        fill_in "パスワード確認", with: "password"
        click_button "登録"

        expect(page).to have_content("ユーザー登録に失敗しました")
        expect(page).to have_content("メールアドレスを入力してください")
        expect(page).to have_current_path("/users")
      end

      it "他者のメールアドレスを使ったとき登録に失敗" do
        other_user = create(:user)
        fill_in "ニックネーム", with: "テストユーザー"
        fill_in "メールアドレス", with: other_user.email
        fill_in "パスワード", with: "password"
        fill_in "パスワード確認", with: "password"
        click_button "登録"

        expect(page).to have_content("ユーザー登録に失敗しました")
        expect(page).to have_content("メールアドレスはすでに存在します")
        expect(page).to have_current_path("/users")
      end

      it "パスワードが空欄のとき登録に失敗" do
        fill_in "ニックネーム", with: "テストユーザー"
        fill_in "メールアドレス", with: "test@sample.com"
        fill_in "パスワード", with: ""
        fill_in "パスワード確認", with: "password"
        click_button "登録"

        expect(page).to have_content("ユーザー登録に失敗しました")
        expect(page).to have_content("パスワードは6文字以上で入力してください")
        expect(page).to have_current_path("/users")
      end

      it "パスワード確認が空欄のとき登録に失敗" do
        fill_in "ニックネーム", with: "テストユーザー"
        fill_in "メールアドレス", with: "test@sample.com"
        fill_in "パスワード", with: "password"
        fill_in "パスワード確認", with: ""
        click_button "登録"

        expect(page).to have_content("ユーザー登録に失敗しました")
        expect(page).to have_content("パスワード確認を入力してください")
        expect(page).to have_current_path("/users")
      end

      it "パスワードとパスワード確認が5文字以下のとき登録に失敗" do
        fill_in "ニックネーム", with: "テストユーザー"
        fill_in "メールアドレス", with: "test@sample.com"
        fill_in "パスワード", with: "short"
        fill_in "パスワード確認", with: "short"
        click_button "登録"

        expect(page).to have_content("ユーザー登録に失敗しました")
        expect(page).to have_content("パスワードは6文字以上で入力してください")
        expect(page).to have_current_path("/users")
      end

      it "パスワードとパスワード確認が一致しないとき登録に失敗" do
        fill_in "ニックネーム", with: "テストユーザー"
        fill_in "メールアドレス", with: "test@sample.com"
        fill_in "パスワード", with: "password"
        fill_in "パスワード確認", with: "password_different"
        click_button "登録"

        expect(page).to have_content("ユーザー登録に失敗しました")
        expect(page).to have_content("パスワード確認とパスワードの入力が一致しません")
        expect(page).to have_current_path("/users")
      end
    end
  end

  describe "User#show" do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

    context "ユーザー詳細画面(ログイン前)" do
      it "未ログイン状態ではアクセスできない" do
        visit user_path(user.id)

        expect(page).to have_content("ログインが必要です")
      end
    end

    context "ユーザー詳細画面(ログイン後)" do
      before { login(user) }

      it "他ユーザーのuserページにアクセスできる" do
        visit user_path(other_user.id)

        expect(page).to have_content("ユーザー情報")
        expect(page).to have_content(other_user.nickname)
      end

      it "自身のuserページにアクセスした場合、profileページに移動する" do
        visit user_path(user.id)

        expect(page).to have_content("マイページ")
      end
    end
  end
end
