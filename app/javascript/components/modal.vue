<template>
  <div>
    <button @click="openModal" class="btn"  :class="buttonClass">

      {{ buttonText }}
      
    </button>

    <ModalDescription v-if="type === 'description'" :show="showModal" @close="showModal = false" />

  </div>
</template>

<script>
import ModalDescription from './ModalDescription.vue'


export default {
  components: {
    ModalDescription
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
      return 'このアプリについて'
    },
    buttonClass() {
      return 'btn-success'
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

