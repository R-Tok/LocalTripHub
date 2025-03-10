require 'rails_helper'

RSpec.describe "User_session", type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:user) { create(:user) }

  describe "User_session#new" do
    context "未ログイン状態でログイン画面にアクセス" do
      it "フォームの内容が正常ならログイン成功 => ログイン状態でトップ画面へ遷移" do
        visit login_path
        fill_in "メールアドレス", with: user.email
        fill_in "パスワード", with: "123456"
        click_button "ログイン"

        expect(page).to have_content("ログインしました")
        expect(page).to have_content("マイページ")
        expect(current_path).to eq root_path
      end

      it "パスワードが空欄 => ログイン失敗" do
        visit login_path
        fill_in "メールアドレス", with: user.email
        fill_in "パスワード", with: ""
        click_button "ログイン"

        expect(page).to have_content("ログインに失敗しました")
        expect(page).to have_content("登録ページへ")
        expect(current_path).to eq login_path
      end

      it "メールアドレスが空欄 => ログイン失敗" do
        visit login_path
        fill_in "メールアドレス", with: ""
        fill_in "パスワード", with: "123456"
        click_button "ログイン"

        expect(page).to have_content("ログインに失敗しました")
        expect(page).to have_content("登録ページへ")
        expect(current_path).to eq login_path
      end
    end
  end

  describe "User_session#destroy" do
    before { login(user) }

    context "ログイン状態でログアウトをクリック" do
      it "正常にログアウト処理が完了する" do
        visit root_path

        find("#header-profile").click
        click_on "ログアウト"

        expect(page).to have_content("ログアウトしました")
        expect(page).to have_content("ログイン")
        expect(current_path).to eq root_path
      end
    end
  end
end
