/*
// モーダルを閉じる
document.getElementById("list-modal").classList.remove("show");
document.querySelector(".modal-backdrop").remove();

// モーダルの中身をリセット
document.getElementById("new-list-form").reset();

// リスト一覧を更新
document.getElementById("list-container").innerHTML = "<%= j render 'list_items', lists: @user.lists %>";
*/
