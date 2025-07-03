<template>
  <div class="landing-page">
    <div class="content">
      <h1 class="main-title">Resources Relationnelles</h1>
      <p class="description">
      </p>

      <div class="features fade-in">
        <n-tag type="success" size="large" round>Partage de ressources</n-tag>
        <n-tag type="info" size="large" round>Communauté engagée</n-tag>
        <n-tag type="warning" size="large" round>Collaboration intuitive</n-tag>
        <n-tag type="error" size="large" round>Sécurité des données</n-tag>
      </div>

      <n-button
        quaternary
        size="large"
        class="discover-button fade-in-button"
        @click="goToRegister"
      >
        Rejoindre la communauté
      </n-button>
    </div>
  </div>
</template>

<script setup>
import { NButton, NTag } from 'naive-ui'
import { useRouter } from 'vue-router'

const router = useRouter()
const goToRegister = () => {
  router.push('/inscription') 
}
</script>

<style scoped>
@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: scale(0.95);
  }
  to {
    opacity: 1;
    transform: scale(1);
  }
}

.landing-page {
  min-height: 100vh;
  background: linear-gradient(to right, #e0f7fa, #ffffff);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 3rem 1rem;
}

.content {
  text-align: center;
  max-width: 700px;
  animation: fadeInUp 1s ease-out;
}

.main-title {
  font-size: 42px;
  font-weight: 700;
  color: #222;
  margin-bottom: 20px;
}

.description {
  font-size: 18px;
  color: #555;
  margin-bottom: 30px;
  line-height: 1.6;
}

.features {
  display: flex;
  justify-content: center;
  gap: 10px;
  flex-wrap: wrap;
  margin-bottom: 40px;
  animation: fadeIn 1.2s ease-out 0.3s forwards;
  opacity: 0;
}

.fade-in-button {
  opacity: 0;
  animation: fadeIn 1s ease-out 0.8s forwards;
}

.discover-button {
  font-size: 16px;
  color: #333;
  transition: all 0.3s ease;
}

.discover-button:hover {
  color: #18a058;
  transform: translateY(-2px);
}
</style>
