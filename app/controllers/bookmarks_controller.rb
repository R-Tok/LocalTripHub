class BookmarksController < ApplicationController
  def create
    post = Post.find(params[:post_id])
    submitted_list_ids = params[:list_ids].reject(&:blank?) || []  # 送信されたフォームのチェック状況

    current_list_ids = post.bookmarks.pluck(:list_id)  # 現在(更新する前)の登録状況
    new_list_ids = submitted_list_ids.map(&:to_i) - current_list_ids  # 新たにチェックが付けられたリスト
    removed_list_ids = current_list_ids - submitted_list_ids.map(&:to_i)  # チェックを外されたリスト

    # 新たに選択されたリストへ登録する
    new_list_ids.each do |list_id|
      Bookmark.find_or_create_by(post_id: post.id, list_id: list_id)
    end

    # 除外されたリストからは既存ブックマークを削除する
    Bookmark.where(post_id: post.id, list_id: removed_list_ids).destroy_all

    respond_to do |format|
      format.js { render inline: "location.reload();" } # 成功後にページをリロード
    end
  end
end
