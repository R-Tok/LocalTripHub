<template>
  <transition name="fade">
    <div v-if="show" class="modal-overlay" @click="close">
      <div class="modal-content" @click.stop>
              <div class="modal-header">
          <h5 class="modal-title">投稿をリストへ追加</h5>
          <button type="button" class="btn-close mx-3" @click="$emit('close')"></button>
        </div>
        <div class="modal-body">
          <h3>aaaa</h3>
          <div v-if="loggedIn">
            <div v-if="userLists.length > 0">
              <form @submit.prevent="submitForm">
                <!-- 隠しフィールド: post_id -->
                <input type="hidden" v-model="post.id" />

                <!-- リストのチェックボックス -->
                <div v-for="list in userLists" :key="list.id" class="d-flex">
                  <input type="checkbox" :value="list.id" v-model="selectedLists" />
                  <span>{{ list.name }}</span>
                </div>

                <!-- 送信ボタン -->
                <button type="submit" class="btn btn-success d-grid mx-auto w-50 my-3">
                  更新する
                </button>
              </form>
            </div>
            <div v-else>
              <p>作成済みリストがありません</p>
              <a :href="listCreationUrl" class="btn btn-success d-grid mx-auto w-50 my-3">
                リスト作成へ移動
              </a>
            </div>
          </div>
        </div>
      </div>
    </div>
  </transition>
</template>

<script>
export default {
  props: {
    show: Boolean,
    post: Object,    // 親コンポーネントから受け取る post データ
    loggedIn: Boolean, // ユーザーがログインしているか
    userLists: Array  // ユーザーのリストデータ
  },
  data() {
    return {
      selectedLists: this.post?.list_ids || [] // 初期状態でチェックされるリスト
    }
  },
  computed: {
    listCreationUrl() {
      return `/users/${this.post.user_id}/lists`; // Railsのルートに合わせる
    }
  },
  emits: ['close'],
  methods: {
    submitForm() {
      const payload = {
        post_id: this.post.id,
        list_ids: this.selectedLists
      };
      
      fetch("/bookmarks", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
        },
        body: JSON.stringify(payload)
      }).then(response => {
        if (response.ok) {
          alert("リストが更新されました！");
          this.$emit("close");
        } else {
          alert("更新に失敗しました。");
        }
      });
    },
    close() {
      this.$emit('close')
    }
  }
}
</script>

<style>
/* シンプルなモーダルのスタイル */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1050; /* モーダルがカルーセルやマップよりも手前に来るように */
}
.modal-content {
  background: white;
  padding: 20px;
  border-radius: 5px;
}
.fade-enter-active, .fade-leave-active {
  transition: opacity .5s;
}
.fade-enter-from, .fade-leave-to {
  opacity: 0;
}
</style>