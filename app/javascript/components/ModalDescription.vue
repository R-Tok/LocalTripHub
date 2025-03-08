<template>
  <transition name="fade">
    <div v-if="show" class="modal-overlay" @click="close">
      <div class="modal-content" @click.stop>
        <div class="d-flex flex-column flex-md-row justify-content-center grid gap-3">
          <div class="text-center bg-body-secondary rounded my-1">
            <h4 class="text-primary my-1">お出かけスポット記録・共有</h4>
            近所で行きつけのお店、ドライブの行先、旅先でふらっと立ち寄った施設…など、何気ない外出だって誰かの小さな旅へと繋がるかも。
            <br>「定番観光地ではなくてもオススメのローカルスポット」を投稿し、ユーザー同士で共有しよう。
           
          </div>
          <div class="text-center bg-body-secondary rounded my-1">
            <h4 class="text-primary my-1">投稿数に応じた塗りつぶし地図</h4>
            <p>「投稿状況マップ」の都道府県地図・市区町村地図は、所在地ごとの投稿スポット数に応じて濃く塗られていく。
            <br>自分の好きな町へ投稿を重ねてアピールするもよし、あまり塗られていない町には何があるんだろう？と新たに発見しに行くもよし。</p>
          </div>
        </div>
        <div class="text-center">
          <button @click="close" class="btn btn-secondary">閉じる</button>
        </div>
      </div>
    </div>
  </transition>
</template>

<script>
export default {
  props: {
    show: Boolean
  },
  emits: ['close'],
  methods: {
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