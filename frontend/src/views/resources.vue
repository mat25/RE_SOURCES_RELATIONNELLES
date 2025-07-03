<template>
  <h1>LES RESSOURCES DU JOUR :</h1>

  <div class="cardContainer">
    <n-card
      v-for="resource in resources"
      :key="resource.id"
      :title="resource.title"
    >
      <template #cover>
        <img :src="resource.image" alt="Illustration" />
      </template>

      <!-- vous pouvez ici afficher resource.content ou un résumé -->

      <template #action>
        <div class="card-actions">
          <n-button type="info">
            Découvrir
          </n-button>

          <!-- ⭐️ FAV -->
          <n-button
            quaternary
            :loading="pendingFavId === resource.id"
            @click="toggleFavorite(resource)"
          >
            <n-icon
              :color="resource.isFavorite ? '#facc15' : 'gray'"
              size="24"
            >
              <!-- icône étoile pleine -->
              <svg
                v-if="resource.isFavorite"
                xmlns="http://www.w3.org/2000/svg"
                viewBox="0 0 24 24"
                fill="currentColor"
              >
                <path
                  d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"
                />
              </svg>

              <!-- icône étoile contour -->
              <svg
                v-else
                xmlns="http://www.w3.org/2000/svg"
                viewBox="0 0 24 24"
                fill="currentColor"
              >
                <path
                  d="m12 15.4-3.76 2.27.99-4.28L6.24 10.5l4.38-.38L12 6l1.38 4.12 4.38.38-2.99 2.89.99 4.28z"
                  fill="none"
                  stroke="currentColor"
                  stroke-width="2"
                  stroke-linejoin="round"
                />
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
/**
 * Hypothèses d’API :
 *  - GET  /api/resources                           → liste des ressources (avec champ isFavorite bool)
 *  - POST /api/resources/{id}/favorites            → ajoute aux favoris
 *  - DELETE /api/resources/{id}/favorites          → retire des favoris
 * Ajuste les URLs si ton back diffère.
 */

import { ref, onMounted } from 'vue'
import { useMessage } from 'naive-ui'
import axios from 'axios'
import { useAuthStore } from '@/stores/auth'

const msg        = useMessage()
const auth       = useAuthStore()
const resources  = ref([])
const pendingFavId = ref(null)  // id de la ressource en cours de (dé)favorisation

/* ---------- récupération de la liste ---------- */
async function fetchResources () {
  try {
    const { data } = await axios.get('/api/resources', {
      headers: { Authorization: `Bearer ${auth.token}` }
    })
    // chaque ressource doit posséder un champ isFavorite booléen
    resources.value = data
  } catch (e) {
    console.error('fetchResources error:', e)
    msg.error('Impossible de charger les ressources.')
  }
}

/* ---------- toggle favoris ---------- */
async function toggleFavorite (resource) {
  if (pendingFavId.value) return       
  pendingFavId.value = resource.id

  try {
    if (resource.isFavorite) {
      await axios.delete(`/api/resources/${resource.id}/favorites`, {
        headers: { Authorization: `Bearer ${auth.token}` }
      })
      resource.isFavorite = false
      msg.success('Retiré des favoris.')
    } else {
      await axios.post(`/api/resources/${resource.id}/favorites`, null, {
        headers: { Authorization: `Bearer ${auth.token}` }
      })
      resource.isFavorite = true
      msg.success('Ajouté aux favoris !')
    }
  } catch (e) {
    console.error('toggleFavorite error:', e?.response?.data || e)
    msg.error('Erreur lors de la mise à jour du favori.')
  } finally {
    pendingFavId.value = null
  }
}

onMounted(() => {
  if (!auth.token && localStorage.getItem('jwt_token')) auth.initializeAuth()
  fetchResources()
})
</script>

<style scoped>
.n-card {
  width: 250px;
  margin: 2rem;
  border: 2px solid rgba(13, 52, 158, 0.15);
}

.n-card :deep(.n-card__action) {
  display: flex;
  justify-content: space-between;
}

.cardContainer {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  background: white;
  padding: 2rem;
  min-height: 60vh;
}

</style>
