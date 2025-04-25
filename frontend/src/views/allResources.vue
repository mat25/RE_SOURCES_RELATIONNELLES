<template>
    <div class="resources-page">
      <header class="resources-header">
        <div class="search-bar">
          <n-input placeholder="Rechercher des ressources..." v-model="searchQuery" @input="handleSearch" />
        </div>
        <div class="filters">
          <div v-for="(filter, key) in filtersConfig" :key="key" class="filter-group">
            <label>{{ filter.label }}</label>
            <n-select
              v-model:value="activeFilters[key]"
              :options="filter.options"
              multiple
              clearable
              @update:value="handleFilterChange(key, $event)"
            />
          </div>
        </div>
      </header>
  
      <section class="resources-list">
        <div v-if="loading" class="loading">Chargement des ressources...</div>
        <div v-else-if="filteredAndPaginatedResources.length > 0" class="resource-grid">
          <div v-for="resource in filteredAndPaginatedResources" :key="resource.id" class="resource-item">
            <div class="resource-image-container">
              <img :src="resource.imageUrl" alt="Image de la ressource" class="resource-image">
            </div>
            <h3 class="resource-title">{{ resource.title }}</h3>
            <p class="resource-description">{{ resource.description.substring(0, 100) }}...</p>
            <div class="resource-actions">
              <n-button class="resource-button" type="primary" size="small">Voir plus</n-button>
              <button class="favorite-button" @click="toggleFavorite(resource.id)" :class="{ 'is-favorite': isFavorite(resource.id) }">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="heart-icon">
                  <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.89l-1.06-1.28a5.5 5.5 0 0 0-7.78 7.78l1.06 1.28L12 21.23l7.78-7.78 1.06-1.28a5.5 5.5 0 0 0 0-7.78z"></path>
                </svg>
              </button>
            </div>
          </div>
        </div>
        <div v-else class="empty-state">Aucune ressource trouvée.</div>
      </section>
  
      <footer class="pagination">
        <n-pagination
          :page="currentPage"
          :page-count="pageCount"
          :page-size="pageSize"
          @update:page="handlePageChange"
          :show-size-picker="true"
          :page-sizes="[10, 20, 50, 100]"
          @update:page-size="handlePageSizeChange"
        />
      </footer>
    </div>
  </template>
  
  <script setup>
  import { ref, computed } from 'vue';
  import { NInput, NSelect, NButton, NPagination } from 'naive-ui';
  
  const loading = ref(false);
  const searchQuery = ref('');
  const activeFilters = ref({});
  const currentPage = ref(1);
  const pageSize = ref(20);
  const favorites = ref([]); // Pour stocker les IDs des ressources favorites
  
  const allResources = ref([
    { id: 1, title: 'Introduction à Vue.js', description: 'Un guide pour débuter avec le framework Vue.js...', category: 'Tutoriel', format: 'Texte', imageUrl: 'https://via.placeholder.com/150/abcdef' },
    { id: 2, title: 'Les composants dans React', description: 'Tout ce que vous devez savoir sur la création de composants réutilisables dans React...', category: 'Tutoriel', format: 'Vidéo', imageUrl: 'https://via.placeholder.com/150/fedcba' },
    { id: 3, title: 'Principes de base de JavaScript', description: 'Un article couvrant les concepts fondamentaux du langage JavaScript...', category: 'Article', format: 'Texte', imageUrl: 'https://via.placeholder.com/150/aabbcc' },
    { id: 4, title: 'Guide avancé de CSS', description: 'Explorez les techniques CSS avancées pour des mises en page complexes...', category: 'Guide', format: 'Texte', imageUrl: 'https://via.placeholder.com/150/bbaa00' },
    { id: 5, title: 'Déploiement d\'une application Node.js', description: 'Un tutoriel pas à pas pour déployer votre application Node.js en production...', category: 'Tutoriel', format: 'Texte', imageUrl: 'https://via.placeholder.com/150/ccddff' },
    { id: 6, title: 'Les Hooks dans React', description: 'Apprenez à utiliser les Hooks pour gérer l\'état et les effets dans vos composants React...', category: 'Article', format: 'Vidéo', imageUrl: 'https://via.placeholder.com/150/ddeeff' },
    { id: 7, title: 'Optimisation des performances en JavaScript', description: 'Conseils et techniques pour améliorer la vitesse de votre code JavaScript...', category: 'Guide', format: 'Texte', imageUrl: 'https://via.placeholder.com/150/eeffaa' },
    { id: 8, title: 'Introduction à TypeScript', description: 'Découvrez les avantages et la syntaxe du langage TypeScript...', category: 'Tutoriel', format: 'Texte', imageUrl: 'https://via.placeholder.com/150/ffaaaa' },
    { id: 9, title: 'Les meilleures pratiques en développement Web', description: 'Un recueil des pratiques recommandées pour écrire du code de qualité...', category: 'Article', format: 'Texte', imageUrl: 'https://via.placeholder.com/150/aaaabb' },
    { id: 10, title: 'Sécurité des applications Web', description: 'Un guide essentiel pour protéger vos applications Web contre les vulnérabilités...', category: 'Guide', format: 'Texte', imageUrl: 'https://via.placeholder.com/150/bbccdd' },
    ...Array.from({ length: 150 }, (_, i) => ({
      id: i + 11,
      title: `Ressource ${String.fromCharCode(65 + (i % 26))}${Math.floor(i / 26) + 1}`,
      description: `Description longue de la ressource ${i + 11}...`,
      category: ['Tutoriel', 'Article', 'Guide'][i % 3],
      format: ['Texte', 'Vidéo', 'PDF'][i % 3],
      imageUrl: `https://via.placeholder.com/150/${Math.floor(Math.random() * 16777215).toString(16)}` // Génère une couleur aléatoire pour l'image
    })),
  ]);
  
  const filtersConfig = ref({
    category: {
      label: 'Catégorie',
      options: [...new Set(allResources.value.map(r => r.category))].map(cat => ({ label: cat, value: cat })),
    },
    format: {
      label: 'Format',
      options: [...new Set(allResources.value.map(r => r.format))].map(fmt => ({ label: fmt, value: fmt })),
    },
  });
  
  const filteredResources = computed(() => {
    return allResources.value.filter(resource => {
      const searchMatch = resource.title.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
                           resource.description.toLowerCase().includes(searchQuery.value.toLowerCase());
  
      const filterMatch = Object.keys(activeFilters.value).every(key => {
        if (!activeFilters.value[key] || activeFilters.value[key].length === 0) {
          return true;
        }
        return activeFilters.value[key].includes(resource[key]);
      });
  
      return searchMatch && filterMatch;
    });
  });
  
  const pageCount = computed(() => Math.ceil(filteredResources.value.length / pageSize.value));
  
  const filteredAndPaginatedResources = computed(() => {
    const startIndex = (currentPage.value - 1) * pageSize.value;
    const endIndex = startIndex + pageSize.value;
    return filteredResources.value.slice(startIndex, endIndex);
  });
  
  const handleSearch = () => {
    currentPage.value = 1;
  };
  
  const handleFilterChange = (key, values) => {
    activeFilters.value[key] = values;
    currentPage.value = 1;
  };
  
  const handlePageChange = (page) => {
    currentPage.value = page;
  };
  
  const handlePageSizeChange = (size) => {
    pageSize.value = size;
    currentPage.value = 1;
  };
  
  const toggleFavorite = (resourceId) => {
    if (favorites.value.includes(resourceId)) {
      favorites.value = favorites.value.filter(id => id !== resourceId);
    } else {
      favorites.value.push(resourceId);
    }
  };
  
  const isFavorite = (resourceId) => {
    return favorites.value.includes(resourceId);
  };
  </script>
  
  <style scoped>
.resources-page {
  padding: 30px;
  font-family: 'Arial', sans-serif;
  color: #333;
}

.resources-header {
  display: flex;
  flex-direction: column;
  gap: 25px;
  margin-bottom: 40px;
  padding-bottom: 20px;
  border-bottom: 1px solid #eee;
}

.search-bar .n-input {
  max-width: 400px;
  border-radius: 20px; /* Ajout de bordures arrondies */
  --n-input-padding: 10px 15px; /* Ajuster le padding pour un meilleur aspect */
}

.filters {
  display: flex;
  gap: 15px; /* Réduire un peu l'écart pour un aspect plus compact */
  flex-wrap: wrap;
}

.filter-group {
  display: flex;
  flex-direction: column;
}

.filter-group label {
  display: block;
  margin-bottom: 5px;
  font-weight: 500;
  color: #555;
  font-size: 0.9em;
}

.filter-group .n-select {
  min-width: 150px;
  border-radius: 15px; /* Ajout de bordures arrondies */
}

.resources-list {
  margin-bottom: 40px;
}

.resource-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 30px;
}

.resource-item {
  border: 1px solid #ddd;
  padding: 25px;
  border-radius: 6px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
  background-color: #f9f9f9;
}

.resource-image-container {
  width: 80px;
  height: 80px;
  overflow: hidden;
  border-radius: 50%;
  margin-bottom: 15px;
}

.resource-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.resource-title {
  margin-top: 0;
  margin-bottom: 12px;
  font-size: 1.1em;
  font-weight: 600;
  color: #222;
}

.resource-description {
  margin-bottom: 20px;
  color: #666;
  font-size: 0.95em;
  line-height: 1.6;
}

.resource-actions {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.resource-button {
  --n-button-color: #222;
  --n-button-text-color: #fff;
  --n-button-border: none;
  border-radius: 15px; /* Ajout de bordures arrondies au bouton principal */
  font-size: 0.85em;
  padding: 10px 20px;
  font-weight: 500;
}

.favorite-button {
  background: none;
  border: none;
  padding: 0;
  cursor: pointer;
  outline: none;
}

.heart-icon {
  width: 20px;
  height: 20px;
  color: #aaa;
}

.favorite-button.is-favorite .heart-icon {
  color: red;
}

.loading, .empty-state {
  text-align: center;
  padding: 30px;
  color: #777;
  font-size: 0.9em;
}

.pagination {
  display: flex;
  justify-content: center;
  padding-top: 20px;
  border-top: 1px solid #eee;
}

.n-pagination {
  /* Les styles par défaut de naive-ui pour la pagination sont généralement déjà assez arrondis */
}
  </style>