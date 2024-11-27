require 'rails_helper'

RSpec.describe "Profiles", type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:user) { create(:user) }

  describe "profiles#show" do
    context "未ログイン状態でprofileにアクセス" do
      it "profile_pathにアクセスできない" do
        visit profile_path

        expect(page).to have_content("ログインが必要です")
      end
    end

    context "ログイン後にprofileにアクセス" do
      before { login(user) }

      it "profile_pathにアクセスし、「マイページ」と自身のメールアドレスが表示される" do
        visit profile_path

        expect(page).to have_content("マイページ")
        expect(page).to have_content(user.email)
      end

      it "ニックネームを変更できる" do
        visit profile_path
        click_on "編集"
        fill_in "ニックネーム", with: "new_nickname"
        click_on "更新"

        expect(page).to have_content("マイページ")
        expect(page).to have_content("new_nickname")
        expect(current_path).to eq profile_path
      end

      it "ニックネームを空欄には編集できない" do
        visit profile_path
        click_on "編集"
        fill_in "ニックネーム", with: ""
        click_on "更新"

        expect(page).to have_content("プロフィール情報更新に失敗しました")
        expect(page).to have_content("ニックネームを入力してください")
        expect(page).to have_content("プロフィール編集")
        expect(current_path).to eq profile_path  # フォームでurl: profile_path というURL指定があるため、edit_profile_pathとしない
      end

      it "自己紹介コメントを変更できる" do
        visit profile_path
        click_on "編集"
        fill_in "自己紹介コメント", with: "Hello!"
        click_on "更新"

        expect(page).to have_content("マイページ")
        expect(page).to have_content("Hello!")
        expect(current_path).to eq profile_path
      end

      it "アイコンを変更できる" do
        visit profile_path
        click_on "編集"
        attach_file("アイコン", Rails.root.join("spec/fixtures/sample_icon.jpg"))
        click_on "更新"

        expect(page).to have_content("マイページ")
        expect(page).to have_selector("img[src$='sample_icon.jpg']")
        expect(current_path).to eq profile_path
      end

      it "退会をキャンセルできる" do
        visit profile_path
        click_on "退会処理へ"
        click_on "退会しない"

        expect(page).to have_content("マイページ")
        expect(current_path).to eq profile_path
      end

      # it "退会処理が実行できる" do
      #   visit profile_path
      #   click_on "退会処理へ"

      #   click_on "退会する"
      #   expect(page.accept_confirm).to eq "本当に退会しますか？"

      #   expect(user.is_deleted).to eq(true)
      #   expect(page).to have_content("退会処理が完了しました")
      #   expect(current_path).to eq root_path
      # end
    end
  end
end
