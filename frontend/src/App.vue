<template>


  <Header>
    <NavigationBar></NavigationBar>
  </Header>



  <main>

    <RouterView />

  </main>


  <Footer />

</template>


<script >
import { CashOutline as CashIcon } from '@vicons/ionicons5'
import { defineComponent } from 'vue'
import Header from "@/components/template/Header.vue";
import NavigationBar from "@/components/organisms/NavigationBar.vue";
import Footer from "@/components/template/Footer.vue";

export default defineComponent({
  components: {
    Header,
    Footer,
    NavigationBar,
    CashIcon
  }
})
</script>



<style scoped>

main{
  width: 100%;
  height: 100vh;
  background-color: rgba(13, 52, 158, 0.15);
}
</style>

