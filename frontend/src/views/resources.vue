<template>
  <h1>LES RESSOURCES DU JOUR :</h1>
  <div class="cardContainer">
    <n-card v-for="(resource, index) in resources" :key="index" :title="resource.title">
      <template #cover>
        <img :src="resource.image">
      </template>
      Card Content
      <template #action>
        <div class="card-actions">
          <n-button type="info">
            Découvrir
          </n-button>
          <n-button quaternary @click="toggleFavorite(index)">
            <n-icon :color="resource.favorite ? 'blue' : 'gray'" size="24">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
                <path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/>
              </svg>
            </n-icon>
          </n-button>
        </div>
      </template>
    </n-card>
  </div>
  <n-button type="info" class="discover-all-btn">
    Découvrir toutes les ressources
  </n-button>
</template>

<script setup>
import { ref } from 'vue';

const resources = ref([
  {
    title: "Card with Cover",
    image: "https://07akioni.oss-cn-beijing.aliyuncs.com/07akioni.jpeg",
    favorite: false
  },
  {
    title: "Card with Cover",
    image: "https://07akioni.oss-cn-beijing.aliyuncs.com/07akioni.jpeg",
    favorite: false
  },
  {
    title: "Card with Cover",
    image: "https://07akioni.oss-cn-beijing.aliyuncs.com/07akioni.jpeg",
    favorite: false
  }
]);

const toggleFavorite = (index) => {
  resources.value[index].favorite = !resources.value[index].favorite;
};

</script>

<style scoped>
.n-card {
  max-width: 250px;
  margin: 3rem auto;
  border: 2px solid rgba(13, 52, 158, 0.15);
}

.n-card :deep(.n-card__action) {
  display: flex;
  justify-content: space-between;
}

.card-actions {
  display: flex;
  align-items: center;
  gap: 8px;
}

.discover-all-btn {
  display: block;
  margin: 0 auto;
  padding: 10px 20px;
  font-size: 1.2rem;
  transform: translateY(-50%);
}

body {
  background-color: rgba(13, 52, 158, 0.15);
}

h1 {
  text-align: center;
  color: rgba(13, 52, 158, 0.75);
  transform: translateY(100%);
}

.allCards {
  display: flex;
  flex-direction: row;
  margin: auto 2rem auto 2rem;
}

img {
  border-bottom: 4px solid black;
}

.cardContainer {
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
