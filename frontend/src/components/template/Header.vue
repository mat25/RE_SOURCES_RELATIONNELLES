<template>
  <header class="header-with-nav">
    <div class="logo">RE-SOCIAL</div>
    <nav class="nav-a-in-header">
      <ul class="nav-links">
        <li>
          <a href="#" class="nav-link">Accueil</a>
        </li>
        <li>
          <a href="#" class="nav-link">Amis</a>
        </li>
        <li>
          <a href="#" class="nav-link">Messages</a>
        </li>
        <li>
          <a href="#" class="nav-link">Notifications</a>
        </li>
      </ul>
    </nav>
    <div class="user-info">
      <n-avatar round :size="36" src="https://i.pravatar.cc/36" />
      <span class="username">Matheo</span>
    </div>
  </header>
</template>

<script setup>
import { NAvatar } from 'naive-ui';
</script>

<style scoped>
.header-with-nav {
  display: flex;
  align-items: center;
  padding: 12px 24px;
  background-color: #6542B1;
  color: white;
}

.logo {
  font-weight: bold;
  font-size: 20px;
  margin-right: 20px; /* Espace entre le logo et la nav */
}

.nav-a-in-header {
  flex-grow: 1; /* Permet à la nav de prendre l'espace central */
  /* Ajoutez d'autres styles si nécessaire pour l'alignement de la nav */
}

.nav-links {
  list-style: none;
  padding: 0;
  margin: 0;
  display: flex;
  justify-content: center; /* Centre les liens de la nav */
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
  margin-left: 20px; /* Espace entre la nav et les infos */
}

.username {
  font-weight: 500;
}
</style>