<template>

  <Header>
    <NavigationBar></NavigationBar>
  </Header>

</template>


<script >
import { CashOutline as CashIcon } from '@vicons/ionicons5'
import { defineComponent } from 'vue'
import Header from "@/components/template/Header.vue";
import NavigationBar from "@/components/organisms/NavigationBar.vue";

export default defineComponent({
  components: {
    Header,
    NavigationBar,
    CashIcon
  }
})
</script>


<style scoped>

</style>