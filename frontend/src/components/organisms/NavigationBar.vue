<template>
  <nav class="navbar">
    <ul class="ul-nav">
      <li v-if="isAuthenticated" class="nav-item">
        <n-avatar :src="userProfileImage" round size="large" class="avatar" />
      </li>
      <li v-else class="nav-item">
        <n-button @click="handleAuthClick" strong secondary round>
          Connexion / Inscription
        </n-button>
      </li>

      <router-link to="/" class="nav-link">
        <n-button strong secondary round>Accueil</n-button>
      </router-link>
      <router-link to="/#" class="nav-link">
        <n-button strong secondary round>Ressources</n-button>
      </router-link>
      <router-link to="/#" class="nav-link">
        <n-button strong secondary round>Progression</n-button>
      </router-link>
    </ul>
  </nav>
</template>

<script lang="ts">
import { defineComponent, ref } from 'vue'
import { NButton, NAvatar } from 'naive-ui'

export default defineComponent({
  components: {
    NButton,
    NAvatar
  },
  setup() {
    const isAuthenticated = ref(false)
    const userProfileImage = ref('https://07akioni.oss-cn-beijing.aliyuncs.com/07akioni.jpeg') // Exemple d'image de profil

    const handleAuthClick = () => {
      if (isAuthenticated.value) {
        isAuthenticated.value = false
      } else {
        isAuthenticated.value = true
      }
    }

    return { isAuthenticated, userProfileImage, handleAuthClick }
  }
})
</script>

<style scoped>
.navbar {
  display: flex;
  gap: 20px;
  align-items: center;
}

.ul-nav {
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

.nav-item {
  list-style: none;
  display: flex;
  align-items: center;
}

.avatar {
  cursor: pointer;
  border: 2px solid #4CAF50;
  transition: transform 0.3s ease;
}

.avatar:hover {
  transform: scale(1.1);
}

.n-button {
  border-radius: 8px;
  padding: 10px 20px;
}

.n-button:hover {
  background-color: #4CAF50;
  color: white;
}
</style>
