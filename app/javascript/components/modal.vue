<template>
  <div>
    <button @click="openModal" class="btn"  :class="buttonClass">
      <template v-if="buttonText === 'aaa'">
        <i class="bi bi-bookmark-heart" style="font-size: 18px;"></i> <!-- buttonTextが'aaa'の場合はアイコンを表示 -->
      </template>
      <template v-else>
        {{ buttonText }}
      </template>
      
    </button>

    <ModalDescription v-if="type === 'description'" :show="showModal" @close="showModal = false" />
    <ModalList
      v-if="type === 'list'"
      :show="showModal"
      :post="post"
      :loggedIn="loggedIn"
      :userLists="userLists"
      :userListsPath="userListsPath"
      @close="closeModal"
    />
  </div>
</template>

<script>
import ModalDescription from './ModalDescription.vue'
import ModalList from './ModalList.vue'

export default {
  components: {
    ModalDescription, ModalList
  },
  props: {
    type: String,  // 'description' または 'list'が入る
    post: Object,
    loggedIn: Boolean,
    userLists: Array,
    userListsPath: String
  },
  data() {
    return {
      showModal: false
    }
  },
  computed: {
    buttonText() {
      return this.type === 'description' ? 'このアプリについて' : 'aaa'
    },
    buttonClass() {
      return this.type === 'description' ? 'btn-success' : 'btn-sm rounded-pill btn-light'
    }
  },
  methods: {
    openModal() {
      
        this.showModal = true;
      
    },
    closeModal() {
      this.showModal = false;
    }
  }
}
</script>

