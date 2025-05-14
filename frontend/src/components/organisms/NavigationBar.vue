<template>
  <nav class="navbar-a">
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
</template>

<style scoped>
.navbar-a {
  display: flex;
  justify-content: center;
  align-items: center;
  background-color: #6542B1;
  padding: 0 16px;
  border-bottom: 1px solid #e0e0e0;
  height: 50px;
}

.nav-links {
  list-style: none;
  padding: 0;
  margin: 0;
  display: flex;
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
</style>