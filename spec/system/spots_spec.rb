require 'rails_helper'

RSpec.describe "Spots", type: :system, js: true do
  before do
    driven_by(:rack_test)
  end

  let(:user) { create(:user) }
  let!(:prefecture) { Prefecture.find_by(id: 1) || create(:prefecture, id: 1, name: "北海道") }
  let!(:municipality) { Municipality.find_by(id: 1) || create(:Municipality, id: 1, name: "札幌市中央区") }

  describe "spot" do
    context "未ログイン状態" do
      it "select_spot_pathにアクセスできない" do
        visit select_spots_path

        expect(page).to have_content("ログインが必要です")
      end

      it "new_spot_pathにアクセスできない" do
        visit new_spot_path

        expect(page).to have_content("ログインが必要です")
      end
    end

    context "ログイン後" do
      before { login(user) }

      it "select_spots_pathに地図が表示される" do
        visit select_spots_path

        expect(page).to have_selector("#created_spot_map")
        expect(page).to have_content("新規投稿 -スポット選択-")
      end

      it "select_spots_path→new_spot_pathへと遷移できる" do
        visit select_spots_path
        click_on "スポット作成ページはこちら"

        expect(page).to have_selector("#spot_create_map")
        expect(page).to have_content("新規投稿 -スポット登録-")
        expect(current_path).to eq new_spot_path
      end

      it "項目が正常なら、確認画面を介してスポット登録できる" do
        visit new_spot_path

        fill_in "スポット名称", with: "おすすめスポット"
        fill_in "緯度", with: 35.123456
        fill_in "経度", with: 140.123456
        find("#spot_prefecture_id").find("option[value='12']").select_option
        find("#spot_municipality_id").find("option[value='621']").select_option
        find("#spot_category_ids_1").click

        click_on "登録"
        click_on "登録する"

        spot = Spot.find_by(name: "おすすめスポット")
        expect(page).to have_content(spot.name)
        expect(page).to have_content("投稿新規作成")
        expect(page).to have_current_path(new_spot_post_path(spot.id))
      end

      it "登録確認画面から「やり直す」で作成画面に戻ることができる" do
        visit new_spot_path

        fill_in "スポット名称", with: "おすすめスポット"
        fill_in "緯度", with: 35.123456
        fill_in "経度", with: 140.123456
        find("#spot_prefecture_id").find("option[value='12']").select_option
        find("#spot_municipality_id").find("option[value='621']").select_option

        click_on "登録"
        click_on "<< やり直す"

        expect(page).to have_content("新規投稿 -スポット登録-")
        expect(page).to have_current_path(new_spot_path)
      end

      it "スポット名が空欄 ⇒失敗" do
        visit new_spot_path

        fill_in "スポット名称", with: ""
        fill_in "緯度", with: 35.123456
        fill_in "経度", with: 140.123456
        find("#spot_prefecture_id").find("option[value='12']").select_option
        find("#spot_municipality_id").find("option[value='621']").select_option

        click_on "登録"

        expect(page).to have_content("スポット名称を入力してください")
        expect(page).to have_content("新規投稿 -スポット登録-")
        expect(page).to have_current_path(confirm_spots_path)
      end

      it "緯度が空欄 ⇒失敗" do
        visit new_spot_path

        fill_in "スポット名称", with: "おすすめスポット"
        fill_in "緯度", with: ""
        fill_in "経度", with: 140.123456
        find("#spot_prefecture_id").find("option[value='12']").select_option
        find("#spot_municipality_id").find("option[value='621']").select_option

        click_on "登録"

        expect(page).to have_content("緯度を入力してください")
        expect(page).to have_content("新規投稿 -スポット登録-")
        expect(page).to have_current_path(confirm_spots_path)
      end

      it "経度が空欄 ⇒失敗" do
        visit new_spot_path

        fill_in "スポット名称", with: "おすすめスポット"
        fill_in "緯度", with: 35.123456
        fill_in "経度", with: ""
        find("#spot_prefecture_id").find("option[value='12']").select_option
        find("#spot_municipality_id").find("option[value='621']").select_option

        click_on "登録"

        expect(page).to have_content("経度を入力してください")
        expect(page).to have_content("新規投稿 -スポット登録-")
        expect(page).to have_current_path(confirm_spots_path)
      end

      it "都道府県が空欄 ⇒失敗" do
        visit new_spot_path

        fill_in "スポット名称", with: "おすすめスポット"
        fill_in "緯度", with: 35.123456
        fill_in "経度", with: 140.123456
        find("#spot_municipality_id").find("option[value='621']").select_option

        click_on "登録"

        expect(page).to have_content("都道府県を入力してください")
        expect(page).to have_content("新規投稿 -スポット登録-")
        expect(page).to have_current_path(confirm_spots_path)
      end

      it "市区町村が空欄 ⇒失敗" do
        visit new_spot_path

        fill_in "スポット名称", with: "おすすめスポット"
        fill_in "緯度", with: 35.123456
        fill_in "経度", with: 140.123456
        find("#spot_prefecture_id").find("option[value='12']").select_option

        click_on "登録"

        expect(page).to have_content("市区町村を入力してください")
        expect(page).to have_content("新規投稿 -スポット登録-")
        expect(page).to have_current_path(confirm_spots_path)
      end

      it "緯度経度に文字列や小数点以下7桁以降を入力 ⇒成功" do
        visit new_spot_path

        fill_in "スポット名称", with: "おすすめスポット"
        fill_in "緯度", with: "35.123456789"
        fill_in "経度", with: 140.123456789
        find("#spot_prefecture_id").find("option[value='12']").select_option
        find("#spot_municipality_id").find("option[value='621']").select_option

        click_on "登録"

        expect(page).to have_content("おすすめスポット")
        expect(page).to have_content("新規投稿 -スポット登録確認-")
        expect(page).to have_current_path(confirm_spots_path)
      end

      it "緯度経度に文字列や小数点以下7桁以降を入力 ⇒成功" do
        visit new_spot_path

        fill_in "スポット名称", with: "おすすめスポット"
        fill_in "緯度", with: 35.123456789
        fill_in "経度", with: 140.123456789
        find("#spot_prefecture_id").find("option[value='12']").select_option
        find("#spot_municipality_id").find("option[value='621']").select_option

        click_on "登録"

        expect(page).to have_content("おすすめスポット")
        expect(page).to have_content("新規投稿 -スポット登録確認-")
        expect(page).to have_current_path(confirm_spots_path)
      end
    end
  end
end
