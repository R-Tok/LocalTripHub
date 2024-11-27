require 'rails_helper'

RSpec.describe "Posts", type: :system, js: true do
  before do
    driven_by(:rack_test)
  end

  let(:user) { create(:user) }

  describe "post" do
    context "未ログイン状態" do
      it "new_contact_pathにアクセスできない" do
        visit new_contact_path

        expect(page).to have_content("ログインが必要です")
        expect(page).to have_current_path(login_path)
      end
    end

    context "ログイン後" do
      before { login(user) }

      it "new_contact_pathにアクセスして内容が正常だと確認画面へ遷移する" do
        visit new_contact_path
        fill_in "ユーザー名", with: "customer_name"
        fill_in "連絡先メールアドレス", with: "customer@sample.com"
        fill_in "件名", with: "問い合わせ件名"
        fill_in "お問い合わせ内容", with: "hogehoge"
        click_on "確認画面へ"

        expect(page).to have_content("お問い合わせ内容確認")
        expect(page).to have_current_path(confirm_contacts_path)
        expect(page).to have_content("hogehoge")

        click_on "送信する"

        expect(page).to have_current_path(done_contacts_path)
        expect(page).to have_content("お問い合わせありがとうございました。")
      end

      it "確認画面から入力画面に戻ることができる" do
        visit new_contact_path
        fill_in "ユーザー名", with: "customer_name"
        fill_in "連絡先メールアドレス", with: "customer@sample.com"
        fill_in "件名", with: "問い合わせ件名"
        fill_in "お問い合わせ内容", with: "hogehoge"
        click_on "確認画面へ"

        expect(page).to have_content("お問い合わせ内容確認")
        expect(page).to have_current_path(confirm_contacts_path)
        expect(page).to have_content("hogehoge")

        click_on "<< 入力へ戻る"

        expect(page).to have_current_path(contacts_path)
        expect(page).to have_content("hogehoge")
      end

      it "nameが空欄 ⇒失敗" do
        visit new_contact_path
        fill_in "ユーザー名", with: ""
        fill_in "連絡先メールアドレス", with: "customer@sample.com"
        fill_in "件名", with: "問い合わせ件名"
        fill_in "お問い合わせ内容", with: "hogehoge"
        click_on "確認画面へ"

        expect(page).to have_content("お問い合わせフォーム")
        expect(page).to have_current_path(confirm_contacts_path)
        expect(page).to have_content("ユーザー名を入力してください")
      end

      it "emailが空欄 ⇒失敗" do
        visit new_contact_path
        fill_in "ユーザー名", with: "customer_name"
        fill_in "連絡先メールアドレス", with: ""
        fill_in "件名", with: "問い合わせ件名"
        fill_in "お問い合わせ内容", with: "hogehoge"
        click_on "確認画面へ"

        expect(page).to have_content("お問い合わせフォーム")
        expect(page).to have_current_path(confirm_contacts_path)
        expect(page).to have_content("連絡先メールアドレスを入力してください")
      end

      it "subjectが空欄 ⇒失敗" do
        visit new_contact_path
        fill_in "ユーザー名", with: "customer_name"
        fill_in "連絡先メールアドレス", with: "customer@sample.com"
        fill_in "件名", with: ""
        fill_in "お問い合わせ内容", with: "hogehoge"
        click_on "確認画面へ"

        expect(page).to have_content("お問い合わせフォーム")
        expect(page).to have_current_path(confirm_contacts_path)
        expect(page).to have_content("件名を入力してください")
      end

      it "messageが空欄 ⇒失敗" do
        visit new_contact_path
        fill_in "ユーザー名", with: "customer_name"
        fill_in "連絡先メールアドレス", with: "customer@sample.com"
        fill_in "件名", with: "問い合わせ件名"
        fill_in "お問い合わせ内容", with: ""
        click_on "確認画面へ"

        expect(page).to have_content("お問い合わせフォーム")
        expect(page).to have_current_path(confirm_contacts_path)
        expect(page).to have_content("お問い合わせ内容を入力してください")
      end

      it "confirm_contacts_pathには直接アクセスできない" do
        visit confirm_contacts_path
        expect(page).to have_content("doesn't exist")
      end
    end
  end
end
