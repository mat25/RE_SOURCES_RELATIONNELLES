<template>
  <div class="page-container">
    <aside class="sidebar-left">
      <h2>Catégories</h2>
      <p v-if="loadingCategories">Chargement…</p>
      <ul v-else>
        <li
          v-for="cat in categories"
          :key="cat.id"
          class="category-item"
        >
          {{ cat.name }}
        </li>
      </ul>
    </aside>

    <main class="main-content">
      <button v-if="isAuthenticated" @click="handleOpenCreateResource">
        Créer une ressource
      </button>

      <p v-if="loadingResources">Chargement…</p>

      <div v-else-if="allResources.length" class="resource-grid">
        <div
          v-for="res in allResources"
          :key="res.id"
          class="resource-item"
        >
          <div class="resource-image-container">
            <img
              src="https://images.pexels.com/photos/4145190/pexels-photo-4145190.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=300&w=400"
              class="resource-image"
            />
          </div>

          <h3 class="resource-title">
            {{ res.title }}
            <span v-if="res.visibility === 'PRIVATE'" style="color: crimson; font-size: 0.8rem;">
              (privée)
            </span>
          </h3>

          <p class="resource-description">
            {{ res.content.slice(0, 100) }}…
          </p>

          <div class="resource-actions">
            <button @click="handleViewResource(res)">Voir plus</button>
            <button @click="toggleFavorite(res)">
              <i
                :class="[
                  'fa-star',
                  isFavorite(res.id) ? 'fas favorite' : 'far'
                ]"
              ></i>
            </button>
          </div>
        </div>
      </div>

      <p v-else>Aucune ressource trouvée.</p>
    </main>

    <!-- Modal -->
    <div v-if="showModal" class="modal-overlay">
      <div class="modal">
        <!-- Formulaire inchangé -->
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { useRouter } from 'vue-router'
import { useMessage } from 'naive-ui'
import { useAuthStore } from '@/stores/auth'

const router = useRouter()
const toast = useMessage()
const auth = useAuthStore()

const isAuthenticated = computed(() => auth.isAuthenticated)
const token = computed(() => auth.token)

const loadingResources = ref(true)
const loadingCategories = ref(true)
const loadingFavorites = ref(false)

const allResources = ref([])
const categories = ref([])
const favorites = ref([])

const showModal = ref(false)

const form = ref({
  title: '',
  content: '',
  videoLink: '',
  visibility: '',
  status: '',
  type: '',
  categoryId: null
})

const isFavorite = (id) => favorites.value.includes(id)

async function fetchResources () {
  try {
    const headers = token.value
      ? { Authorization: `Bearer ${token.value}` }
      : {}

    const res = await fetch('/api/resources?size=1000', { headers })
    if (!res.ok) throw new Error(`HTTP ${res.status}`)

    const data = await res.json()
    allResources.value = Array.isArray(data) ? data : data.content ?? []
  } catch (err) {
    console.error('[fetchResources]', err)
    toast.error('Impossible de charger les ressources.')
  } finally {
    loadingResources.value = false
  }
}


async function fetchCategories () {
  try {
    const res = await fetch('/api/category')
    if (!res.ok) throw new Error(`HTTP ${res.status}`)
    categories.value = await res.json()
  } catch (err) {
    console.error('[fetchCategories]', err)
    toast.error('Impossible de charger les catégories.')
  } finally {
    loadingCategories.value = false
  }
}

async function fetchFavorites () {
  if (!token.value) return
  loadingFavorites.value = true
  try {
    const res = await fetch('/api/resources/favorites', {
      headers: { Authorization: `Bearer ${token.value}` }
    })
    if (!res.ok) throw new Error(`HTTP ${res.status}`)
    const data = await res.json()
    favorites.value = data.map(r => r.id)
  } catch (err) {
    console.error('[fetchFavorites]', err)
    toast.error('Impossible de récupérer vos favoris.')
  } finally {
    loadingFavorites.value = false
  }
}

async function toggleFavorite (res) {
  if (!isAuthenticated.value) {
    router.push('/connexion')
    return
  }
  try {
    const resp = await fetch(`/api/resources/${res.id}/toggle-favorite`, {
      method: 'POST',
      headers: { Authorization: `Bearer ${token.value}` }
    })
    if (!resp.ok) throw new Error(`HTTP ${resp.status}`)
    const idx = favorites.value.indexOf(res.id)
    idx === -1 ? favorites.value.push(res.id) : favorites.value.splice(idx, 1)
  } catch (err) {
    console.error('[toggleFavorite]', err)
    toast.error('Impossible de mettre à jour le favori.')
  }
}

const handleViewResource = (r) => {
  isAuthenticated.value
    ? router.push({ name: 'detailRessource', params: { id: r.id } })
    : router.push('/connexion')
}

const handleOpenCreateResource = () => {
  isAuthenticated.value
    ? (showModal.value = true)
    : router.push('/connexion')
}

async function submitResource () {
  try {
    const res = await fetch('/api/resources', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${token.value}`
      },
      body: JSON.stringify(form.value)
    })
    if (!res.ok) throw new Error(`HTTP ${res.status}`)

    toast.success('Ressource créée !')
    showModal.value = false
    await fetchResources()
  } catch (err) {
    console.error('[submitResource]', err)
    toast.error('Création impossible.')
  }
}

onMounted(async () => {
  await Promise.all([fetchResources(), fetchCategories()])
  await fetchFavorites()
})

watch(token, (t) => {
  if (t) fetchFavorites()
})
</script>



<style scoped>
@import url('https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css');

.page-container {
  display: flex;
  height: 100vh;
  background-color: #f9fafb;
  overflow: hidden;
}

.sidebar-left {
  flex: 0 0 250px;
  background: #f0f0f0;
  padding: 16px;
  overflow-y: auto;
  border-right: 1px solid #ddd;
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
  display: flex;
  gap: 10px;
}

.resource-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
  gap: 16px;
}

.resource-item {
  border: 1px solid #ddd;
  border-radius: 8px;
  padding: 16px;
  background: #fff;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}

.resource-image-container {
  width: 100%;
  height: 150px;
  overflow: hidden;
  margin-bottom: 10px;
}

.resource-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.resource-title {
  margin: 0 0 10px;
  font-weight: 600;
  font-size: 1.1rem;
}

.resource-description {
  flex-grow: 1;
  font-size: 0.9rem;
  color: #444;
  margin-bottom: 10px;
}

.resource-actions {
  display: flex;
  justify-content: space-between;
  gap: 10px;
}

button {
  cursor: pointer;
  padding: 6px 12px;
  border: none;
  border-radius: 4px;
  background-color: #3490dc;
  color: white;
  font-weight: 600;
  transition: background-color 0.3s ease;
}

button:hover {
  background-color: #2779bd;
}

.loading,
.empty-state {
  text-align: center;
  font-style: italic;
  margin-top: 40px;
  color: #666;
}

.pagination {
  margin-top: 20px;
  text-align: center;
}

.pagination button {
  background-color: #3490dc;
  margin: 0 5px;
}

.favorite {
  color: gold;
  transition: color 0.3s ease;
}


.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.modal {
  background: white;
  padding: 24px;
  border-radius: 8px;
  width: 400px;
  max-width: 90%;
}

.sidebar-left {
  flex: 0 0 250px;
  background: #f0f0f0;
  padding: 16px;
  overflow-y: auto;
  border-right: 1px solid #ddd;
}

.category-item {
  padding: 8px 0;
  font-size: 0.95rem;
  color: #333;
  border-bottom: 1px solid #e0e0e0;
}


.modal-actions {
  margin-top: 16px;
  display: flex;
  justify-content: flex-end;
  gap: 10px;
}

input,
textarea,
select {
  width: 100%;
  padding: 8px;
  margin-bottom: 12px;
  border: 1px solid #ccc;
  border-radius: 4px;
  font-size: 1rem;
}
</style>
