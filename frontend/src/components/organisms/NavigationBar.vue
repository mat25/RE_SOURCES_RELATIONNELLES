<template>
  <nav class="navbar">

    <ul class="ul-nav" >
      <router-link to="/inscription" class="nav-link-ava"><n-avatar
          round
          size="large"
          src="https://07akioni.oss-cn-beijing.aliyuncs.com/07akioni.jpeg"
      /></router-link>
      <router-link to="/" class="nav-link">    <n-button strong secondary round>Accueil</n-button></router-link>
      <router-link to="/#" class="nav-link">    <n-button strong secondary round>Ressources</n-button></router-link>
      <router-link to="/#" class="nav-link">    <n-button strong secondary round>Progression</n-button></router-link>
    </ul>

  </nav>
</template>


<style scoped>
.navbar {
  display: flex;
  gap: 20px;
}

.ul-nav{
  border: white 4px solid;
  border-radius: 10px;
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 0;
  margin: 0;
}

.nav-link {
  color: white;
  text-decoration: none;
  font-weight: bold;
  padding: 10px;
}

.nav-link-ava{
  margin-top: 0.3rem ;
  margin-right: 1rem;
}



</style>


<script lang="ts">
import { CashOutline as CashIcon } from '@vicons/ionicons5'
import { defineComponent } from 'vue'

export default defineComponent({
  components: {
    CashIcon
  }
})
</script>




