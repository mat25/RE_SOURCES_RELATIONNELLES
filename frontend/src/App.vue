<template>


  <Header>
    <NavigationBar></NavigationBar>
  </Header>

  <main>

    <h1>LES RESSOURCES DU JOUR :</h1>


    <div class="cardContainer">

      <n-card title="Card with Cover">
        <template #cover>
          <img src="https://07akioni.oss-cn-beijing.aliyuncs.com/07akioni.jpeg">
        </template>
        Card Content
        <template #action>
          <n-button type="info" >
            Decouvrir
          </n-button>
        </template>
      </n-card>


      <n-card title="Card with Cover">
        <template #cover>
          <img src="https://07akioni.oss-cn-beijing.aliyuncs.com/07akioni.jpeg">
        </template>
        Card Content
        <template #action>
          <n-button type="info">
            Decouvrir
          </n-button>
        </template>
      </n-card>


      <n-card title="Card with Cover">
        <template #cover>
          <img src="https://07akioni.oss-cn-beijing.aliyuncs.com/07akioni.jpeg">
        </template>
        Card Content
        <template #action>
          <n-button type="info">
            Decouvrir
          </n-button>
        </template>
      </n-card>
      </div>

    <n-button type="info" class="discover-all-btn">
      Decouvrir toutes les ressources
    </n-button>

  </main>


  <slot></slot>
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

.n-card {
  max-width: 300px;
  margin: 5rem auto;

}

.n-card :deep(.n-card__action) {
  display: flex;
  justify-content: center;
}

.discover-all-btn {
  display: block;
  margin: 0 auto;
  padding: 10px 20px;
  font-size: 1.2rem;
  transform: translateY(-50%);
}


body{
  background-color: rgba(13, 52, 158, 0.15);
}

main{
  width: 100%;
  height: 100vh;
  background-color: rgba(13, 52, 158, 0.15);
}

h1{
  text-align: center;
  color: rgba(13, 52, 158, 0.75);
  transform: translateY(150%);
}


.allCards{
  display: flex;
  flex-direction: row;
  margin: auto 2rem auto 2rem;
}

img{
  border-bottom: 4px solid black;
}

.cardContainer{
  display: flex;
  justify-content: center;
  align-items: center;
  flex-direction: row;
  background-color: white;
  height: 80vh;
  width: 80vw;
  margin: 0 auto;
}

</style>

