<template>
  <div class="page-container">
    <div class="main-content">
      <header class="resources-header">
        <div class="search-bar">
          <n-input
            placeholder="Rechercher des ressources..."
            v-model:value="searchQuery"
            @input="handleSearch"
            clearable
          />
        </div>
        <div class="filter-pills">
          <div
            v-for="(filterConfig, key) in filtersConfig"
            :key="key"
            class="filter-group-pills"
          >
            <span class="filter-label">{{ filterConfig.label }}:</span>
            <CustomVioletButton
              v-for="option in filterConfig.options"
              :key="option.value"
              :label="option.label"
              :value="option.value"
              v-model="activeFilters[key]"
              @click="toggleFilter(key, option.value)"
            />
          </div>
        </div>
        <div class="add-resource-bar">
          <CustomVioletButton label="+ Ajouter une ressource" @click="handleAddResource" />
        </div>
      </header>

      <section class="resources-list">
        <div v-if="loading" class="loading">Chargement des ressources...</div>
        <div v-else-if="filteredAndPaginatedResources.length > 0" class="resource-grid">
          <div
            v-for="resource in filteredAndPaginatedResources"
            :key="resource.id"
            class="resource-item"
          >
            <div class="resource-image-container">
              <img
                :src="resource.imageUrl"
                alt="Image de la ressource"
                class="resource-image"
              />
            </div>
            <h3 class="resource-title">{{ resource.title }}</h3>
            <p class="resource-description">
              {{ resource.description.substring(0, 100) }}...
            </p>
            <div class="resource-actions">
              <CustomVioletButton label="Voir plus" @click="handleViewResource(resource)" />
              <CustomVioletButton
                :label="isFavorite(resource.id) ? '' : ''"
                :class="{ 'active': isFavorite(resource.id) }"
                @click="toggleFavorite(resource)"
              >
                <i :class="isFavorite(resource.id) ? 'fas fa-star' : 'far fa-star'"></i>
              </CustomVioletButton>
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
        />
      </footer>
    </div>

    <div class="sidebar-right" style="background: #6542b1; color: white;">
      <h3>Groupes</h3>
      <ul class="groups-list">
        <li v-for="group in groups" :key="group.id">
          <span>{{ group.name }}</span>
        </li>
      </ul>
      <h3>Amis</h3>
      <ul class="friends-list">
        <li v-for="friend in friends" :key="friend.id">
          <img :src="friend.avatar" alt="Avatar" class="friend-avatar" />
          <span>{{ friend.name }}</span>
        </li>
      </ul>
      <h3>Messages</h3>
      <ul class="messages-list">
        <li v-for="message in messages" :key="message.id">
          <span class="message-from">{{ message.from }}</span>:
          {{ message.text }}
        </li>
      </ul>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue';
import { NInput, NPagination } from 'naive-ui';
import CustomVioletButton from '../components/atom/CustomVioletButton.vue';

const loading = ref(false);
const searchQuery = ref('');
const activeFilters = ref({});
const currentPage = ref(1);
const pageSize = ref(20);
const favorites = ref([]);
const groups = ref([
  { id: 1, name: 'Développement Web' },
  { id: 2, name: 'Design UI/UX' },
  { id: 3, name: 'Marketing Digital' },
]);

const toggleFavorite = (resource) => {
  const index = favorites.value.indexOf(resource.id);
  if (index === -1) {
    favorites.value.push(resource.id);
  } else {
    favorites.value.splice(index, 1);
  }
};

const isFavorite = (id) => favorites.value.includes(id);

const friends = ref([
  { id: 1, name: 'Alice', avatar: 'https://via.placeholder.com/50/abc' },
  { id: 2, name: 'Bob', avatar: 'https://via.placeholder.com/50/def' },
  { id: 3, name: 'Charlie', avatar: 'https://via.placeholder.com/50/ghi' },
]);

const messages = ref([
  { id: 1, from: 'Alice', text: 'Salut ! Comment ça va ?' },
  { id: 2, from: 'Bob', text: 'Hey, on se voit ce soir ?' },
  { id: 3, from: 'Charlie', text: 'Tu veux sortir ce week-end ?' },
]);

const allResources = ref([
  { id: 1, title: 'Introduction à Vue.js', description: 'Un guide pour débuter...', category: 'Tutoriel', format: 'Texte', imageUrl: 'https://via.placeholder.com/150/abcdef' },
  { id: 2, title: 'Composants React', description: 'Créer des composants...', category: 'Tutoriel', format: 'Vidéo', imageUrl: 'https://via.placeholder.com/150/fedcba' },
  { id: 3, title: 'Base de JavaScript', description: 'Concepts JS de base...', category: 'Article', format: 'Texte', imageUrl: 'https://via.placeholder.com/150/aabbcc' },
  { id: 4, title: 'Guide CSS avancé', description: 'Techniques CSS poussées...', category: 'Guide', format: 'Texte', imageUrl: 'https://via.placeholder.com/150/bbaa00' },
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
    const matchSearch = resource.title.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
                        resource.description.toLowerCase().includes(searchQuery.value.toLowerCase());

    const matchFilters = Object.keys(activeFilters.value).every(key => {
      const selected = activeFilters.value[key];
      return !selected?.length || selected.includes(resource[key]);
    });

    return matchSearch && matchFilters;
  });
});

const pageCount = computed(() => Math.ceil(filteredResources.value.length / pageSize.value));

const filteredAndPaginatedResources = computed(() => {
  const start = (currentPage.value - 1) * pageSize.value;
  return filteredResources.value.slice(start, start + pageSize.value);
});

const handleSearch = () => {
  currentPage.value = 1;
};

const toggleFilter = (key, value) => {
  if (!activeFilters.value[key]) {
    activeFilters.value[key] = [];
  }
  const index = activeFilters.value[key].indexOf(value);
  if (index === -1) {
    activeFilters.value[key].push(value);
  } else {
    activeFilters.value[key].splice(index, 1);
  }
  currentPage.value = 1;
};

const handlePageChange = (page) => {
  currentPage.value = page;
};

const handlePageSizeChange = (size) => {
  pageSize.value = size;
  currentPage.value = 1;
};

const handleAddResource = () => {
  console.log('Ajouter une ressource cliqué');
  // Ajoutez ici votre logique pour ajouter une ressource
};

const handleViewResource = (resource) => {
  console.log('Voir plus pour la ressource:', resource);
  // Ajoutez ici votre logique pour afficher plus de détails sur la ressource
};
</script>

<style scoped>
@import url('https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css');

.page-container {
  display: flex;
  height: 100vh;
  background-color: #f9fafb;
  overflow: hidden;
}

/* Suppression de la barre latérale gauche */
.sidebar-left {
  display: none;
}

.sidebar-right {
  flex: 0 0 250px;
  background: #6542b1;
  padding: 16px;
  overflow-y: auto;
  border-left: 1px solid #ddd;
  color: white; /* Texte blanc pour la sidebar */
}

.main-content {
  flex: 1;
  padding: 20px;
  display: flex;
  flex-direction: column;
  overflow-y: auto;
}

.search-bar {
  margin-bottom: 20px;
}

/* Style pour les filtres sous forme de cases (pills) */
.filter-pills {
  margin-bottom: 20px;
  padding: 10px 0;
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  align-items: center;
}

.filter-group-pills {
  display: flex;
  gap: 8px;
  align-items: center;
}

.filter-label {
  font-weight: bold;
  color: #333;
}

.add-resource-bar {
  margin-bottom: 20px;
  display: flex;
  justify-content: flex-end;
}

.resource-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
  gap: 20px;
}

.resource-item {
  background: white;
  border-radius: 12px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
  padding: 16px;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}

.resource-image-container {
  height: 140px;
  overflow: hidden;
  margin-bottom: 12px;
}

.resource-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.resource-title {
  font-size: 1.1rem;
  font-weight: bold;
  margin: 8px 0;
}

.resource-description {
  font-size: 0.9rem;
  color: #555;
  margin-bottom: 12px;
}

.resource-actions {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 8px;
}

.groups-list, .friends-list, .messages-list {
  list-style: none;
  padding: 0;
  margin: 0 0 20px 0;
}

.friend-avatar {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  margin-right: 8px;
}

.message-from {
  font-weight: bold;
}

.pagination {
  margin-top: 24px;
  display: flex;
  justify-content: center;
}
</style>