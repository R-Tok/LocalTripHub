<template>
  <div id="lightbox">

    <vue-easy-lightbox
      :visible="visibleRef"
      :imgs="imgsRef"
      :index="indexRef"
      @hide="onHide"
    ></vue-easy-lightbox>
  </div>
</template>

<script>
import VueEasyLightbox from 'vue-easy-lightbox'
import { ref, defineComponent, onMounted } from 'vue'
export default defineComponent({
  components: {
    VueEasyLightbox
  },
  setup() {
    const visibleRef = ref(false)
    const indexRef = ref(0) // default 0
    const imgsRef = ref([])

    onMounted(() => {
      document.addEventListener('click', (event) => {
        if (event.target.classList.contains('lightbox-img')) {
          showMultiple(event.target.dataset.image)
        }
      })
    })

    const showMultiple = (src) => {
      imgsRef.value = Array.from(document.querySelectorAll('.lightbox-img')).map(img => img.dataset.image)
      indexRef.value = imgsRef.value.indexOf(src)
      onShow()
    }

    const onShow = () => (visibleRef.value = true)
    const onHide = () => (visibleRef.value = false)
    
    return {
      visibleRef,
      indexRef,
      imgsRef,
      showMultiple,
      onHide
    }
  }
})
</script>