/*
// モーダル内にメッセージを表示
const modalBody = document.querySelector("#addToListModal-<%= params[:post_id] %> .modal-body");
modalBody.insertAdjacentHTML("beforeend", "<div class='alert alert-success mt-3'>リストへの保存を更新しました</div>");

// メッセージを一定時間後に削除
setTimeout(() => {
  const alert = modalBody.querySelector(".alert");
  if (alert) alert.remove();
}, 3000);

// フォームのボタンを再有効化
const submitButton = modalBody.querySelector("input[type='submit']");
if (submitButton) submitButton.disabled = false;
*/