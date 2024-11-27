require 'rails_helper'

RSpec.describe "Posts", type: :system, js: true do
  before do
    driven_by(:rack_test)
  end

  let(:user) { create(:user) }
  let!(:prefecture) { Prefecture.find_by(id: 1) || create(:prefecture, id: 1, name: "北海道") }
  let!(:municipality) { Municipality.find_by(id: 1) || create(:Municipality, id: 1, name: "札幌市中央区") }
  let(:spot) { create(:spot, user: user, prefecture: prefecture, municipality: municipality) }

  describe "post" do
    context "未ログイン状態" do
      let!(:post) { create(:post, spot: spot, user: user) }

      it "spot_posts_pathにアクセスできない" do
        visit spot_posts_path(spot.id)

        expect(page).to have_content("ログインが必要です")
        expect(page).to have_current_path(login_path)
      end

      it "new_spot_post_pathにアクセスできない" do
        visit new_spot_post_path(spot.id)

        expect(page).to have_content("ログインが必要です")
      end

      it "spot_post_pathにはアクセスできる" do
        visit spot_post_path(spot.id, post.id)

        expect(page).to have_content(spot.name)
        expect(page).to have_content(post.user.nickname)
      end

      it "edit_spot_post_pathにアクセスできない" do
        visit edit_spot_post_path(spot.id, post.id)

        expect(page).to have_content("ログインが必要です")
      end
    end

    context "ログイン後" do
      let!(:another_user) { create(:user) }
      let!(:post) { create(:post, spot: spot, user: user) }

      it "spot_posts_pathにpost一覧が表示される" do
        login(user)
        visit spot_posts_path(spot.id)

        expect(page).to have_content(spot.name)
      end

      it "項目が正常なら新規投稿できる" do
        login(user)
        visit new_spot_post_path(spot.id)
        fill_in "本文(見どころ・感想)", with: "わんこかわいい"
        fill_in "アクセス・営業時間など", with: "いつでも"
        image = create(:image, post: post)
        click_on "投稿する"

        expect(page).to have_current_path(spot_posts_path(spot.id))
        expect(page).to have_content(spot.name)
        expect(page).to have_selector("img[src$='sample_image.jpg']")
        expect(page).to have_content("投稿一覧")
        expect(page).to have_content("投稿が作成されました")
      end

      it "本文がない場合、投稿作成に失敗する" do
        login(user)
        visit new_spot_post_path(spot.id)
        fill_in "本文(見どころ・感想)", with: ""
        fill_in "アクセス・営業時間など", with: "いつでも"
        click_on "投稿する"

        expect(current_path).to eq spot_posts_path(spot.id)
        expect(page).to have_content("投稿の作成に失敗しました")
        expect(page).to have_content("投稿新規作成")
      end

      it "postと同じユーザーの場合は編集画面にアクセスできる" do
        login(user)
        visit edit_spot_post_path(spot.id, post.id)

        expect(page).to have_content(spot.name)
        expect(page).to have_content("投稿編集")
      end

      it "postと異なるユーザーの場合は編集画面にアクセスできない" do
        login(another_user)
        visit edit_spot_post_path(spot.id, post.id)

        expect(page).to have_content("doesn't exist")
      end
    end
  end
end
