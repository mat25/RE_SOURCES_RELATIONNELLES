<template>
  <header class="header-with-nav">
    <div class="logo">RE-SOCIAL</div>

    <nav class="nav-a-in-header">
      <ul class="nav-links">
        <li><router-link to="/" class="nav-link">Accueil</router-link></li>
        <li><router-link to="/allResource" class="nav-link">Ressources</router-link></li>
        <li v-if="showBackOffice"><router-link to="/backOffice" class="nav-link">Back Office</router-link></li>
      </ul>
    </nav>

    <div class="user-info">
      <template v-if="auth.isAuthenticated">
        <div class="profile-link" @click="goToProfile">
          <n-avatar round :size="36" :src="auth.user?.avatarUrl || 'https://i.pravatar.cc/36'" />
          <span class="username">{{ auth.user?.name || 'Utilisateur' }}</span>
        </div>
        <button class="logout-btn" @click="logout">Déconnexion</button>
      </template>

      <template v-else>
        <button @click="redirectToAuth" class="auth-btn">Connexion / Inscription</button>
      </template>
    </div>
  </header>
</template>


<script setup>
import { useRouter } from 'vue-router'
import { computed, onMounted } from 'vue'
import { useAuthStore } from '@/stores/auth'
import { NAvatar } from 'naive-ui'

const router = useRouter()
const auth = useAuthStore()

onMounted(() => {
  if (auth.isAuthenticated) {
    auth.fetchUser()
  }
})

// Afficher Back Office si rôle autorisé
const showBackOffice = computed(() => {
  const role = auth.user?.role?.name?.toUpperCase?.()
  return ['ADMIN', 'MODERATEUR', 'SUPER_ADMIN'].includes(role)
})

const redirectToAuth = () => {
  router.push('/inscription')
}

const goToProfile = () => {
  router.push('/profil')
}

const logout = () => {
  auth.logout()
  router.push('/')
}
</script>

<style scoped>
.header-with-nav {
  display: flex;
  align-items: center;
  padding: 12px 24px;
  background-color: #6542b1;
  color: white;
}

.logo {
  font-weight: bold;
  font-size: 20px;
  margin-right: 20px;
}

.nav-a-in-header {
  flex-grow: 1;
}

.nav-links {
  list-style: none;
  padding: 0;
  margin: 0;
  display: flex;
  justify-content: center;
}

.nav-links li {
  margin: 0 15px;
}

.nav-link {
  text-decoration: none;
  color: white;
  padding: 8px 12px;
  border-radius: 8px;
  transition: background-color 0.3s ease;
}

.nav-link:hover {
  background-color: rgba(255, 255, 255, 0.1);
}

.user-info {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-left: 20px;
}

.profile-link {
  display: flex;
  align-items: center;
  gap: 10px;
  cursor: pointer;
}

.username {
  font-weight: 500;
}

.auth-btn,
.logout-btn {
  padding: 8px 12px;
  border: none;
  background-color: #6542b1;
  color: white;
  border-radius: 4px;
  cursor: pointer;
}

.auth-btn:hover,
.logout-btn:hover {
  background-color: #54359e;
}
</style>
