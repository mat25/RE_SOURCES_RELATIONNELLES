<template>
  <div class="resource-detail">
    <h1>{{ resource.title }}</h1>

      <n-button
        size="small"
        :type="resource.isExploited ? 'success' : 'default'"
        @click="toggleExploited"
      >
        {{ resource.isExploited ? 'Annuler exploité' : 'Marquer exploité' }}
      </n-button>

    <p><strong>Créé le :</strong> {{ formatDate(resource.creationDate) }}</p>

    <p>
      <strong>Type :</strong> {{ resource.type }} |
      <strong>Statut :</strong> {{ resource.status }}
    </p>

    <p><strong>Catégorie :</strong> {{ resource.category }}</p>

    <p v-if="resource.videoLink">
      🎥
      <a :href="resource.videoLink" target="_blank">Voir la vidéo</a>
    </p>

    <p class="content">{{ resource.content }}</p>

    <section class="comments">
      <h2>Commentaires</h2>

      <div v-if="comments.length">
        <div v-for="comment in comments" :key="comment.id" class="comment">
          <p class="meta">
            <strong>{{ comment.authorUsername }}</strong> —
            {{ formatDate(comment.createdAt) }}
          </p>
          <p>{{ comment.content }}</p>

          <div class="reply">
            <n-input
              v-model:value="replies[comment.id]"
              placeholder="Répondre à ce commentaire…"
            />
            <n-button size="small" @click="submitReply(comment.id)">
              Répondre
            </n-button>
          </div>

          <div
            v-if="comment.replies && comment.replies.length"
            class="sub-comments"
          >
            <div
              v-for="reply in comment.replies"
              :key="reply.id"
              class="comment reply-comment"
            >
              <p class="meta">
                <strong>{{ reply.authorUsername }}</strong> —
                {{ formatDate(reply.createdAt) }}
              </p>
              <p>{{ reply.content }}</p>
            </div>
          </div>
        </div>
      </div>
      <p v-else>Aucun commentaire pour cette ressource.</p>

      <div style="margin-top: 20px">
        <n-input
          v-model:value="newComment"
          placeholder="Écrire un commentaire…"
          type="textarea"
          rows="3"
          maxlength="500"
          show-count
        />

        <n-button
          type="primary"
          :loading="loadingSend"
          style="margin-top: 12px"
          @click="submitComment"
        >
          Envoyer
        </n-button>
      </div>
    </section>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useMessage } from 'naive-ui'
import axios from 'axios'
import { useAuthStore } from '@/stores/auth'

const route = useRoute()
const router = useRouter()
const msg    = useMessage()
const auth   = useAuthStore()

const id           = route.params.id
const resource     = ref({})
const comments     = ref([])
const newComment   = ref('')
const loadingSend  = ref(false)
const replies      = ref({}) 

const formatDate = iso => {
  if (!iso || isNaN(new Date(iso).getTime())) return 'Date invalide'
  return new Intl.DateTimeFormat('fr-FR', {
    dateStyle: 'short',
    timeStyle: 'short'
  }).format(new Date(iso))
}

/* ---------------------------- API calls ---------------------------- */
async function fetchResource() {
  try {
    const { data } = await axios.get(`/api/resources/${id}`)
    resource.value = data
  } catch (e) {
    console.error('[fetchResource] error:', e)
    msg.error('Erreur lors du chargement de la ressource.')
  }
}

async function fetchComments() {
  try {
    const { data } = await axios.get(`/api/resources/${id}/comments`, {
      headers: { Authorization: `Bearer ${auth.token}` }
    })
    comments.value = data
  } catch (e) {
    console.error('[fetchComments] error:', e)
    msg.error('Erreur lors du chargement des commentaires.')
  }
}

async function submitComment () {
  if (!newComment.value.trim()) {
    return msg.warning('Le commentaire ne peut pas être vide.')
  }

  loadingSend.value = true
  try {
    await axios.post(
      `/api/resources/${id}/comments`,
      { content: newComment.value },
      { headers: { Authorization: `Bearer ${auth.token}` } }
    )

    newComment.value = ''
    await fetchComments()
    msg.success('Commentaire ajouté.')
  } catch (e) {
    const error = e?.response?.data || e
    if ([401, 403].includes(e?.response?.status)) {
      msg.error('Non autorisé, veuillez vous reconnecter.')
      auth.logout()
      router.push('/connexion')
    } else {
      msg.error("Erreur lors de l'ajout du commentaire.")
    }
  } finally {
    loadingSend.value = false
  }
}

async function submitReply (parentId) {
  const content = replies.value[parentId]?.trim()
  if (!content) return msg.warning('La réponse est vide.')

  try {
    await axios.post(
      `/api/resources/${id}/comments`,
      { content, parentId },
      { headers: { Authorization: `Bearer ${auth.token}` } }
    )

    replies.value[parentId] = ''
    await fetchComments()
    msg.success('Réponse envoyée.')
  } catch (e) {
    const error = e?.response?.data || e
    if ([401, 403].includes(e?.response?.status)) {
      msg.error('Non autorisé, veuillez vous reconnecter.')
      auth.logout()
      router.push('/connexion')
    } else {
      msg.error('Erreur lors de la réponse.')
    }
  }
}

async function toggleExploited () {
  try {
    const { status } = await axios.post(
      `/api/resources/${id}/toggle-exploited`,
      {},
      { headers: { Authorization: `Bearer ${auth.token}` } }
    )

    if (status === 200) {
      resource.value.isExploited = !resource.value.isExploited
      msg.success(
        resource.value.isExploited
          ? 'Ressource marquée comme exploitée'
          : 'Ressource retirée des exploitées'
      )
    }
  } catch (e) {
    console.error('[toggleExploited] error:', e)
    msg.error("Impossible de changer l'état exploité.")
  }
}

onMounted(async () => {
  if (!auth.token && localStorage.getItem('jwt_token')) {
    auth.initializeAuth()
  }

  if (!auth.token) {
    router.push('/connexion')
    return
  }

  await Promise.all([fetchResource(), fetchComments()])
})
</script>


<style scoped>
.resource-detail {
  max-width: 900px;
  margin: 2rem auto;
  padding: 2.5rem;
  background-color: #ffffff;
  border-radius: 12px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
  font-family: 'Segoe UI', sans-serif;
}

.resource-detail h1 {
  font-size: 2rem;
  margin-bottom: 0.5rem;
  color: #2c3e50;
}

.resource-detail p {
  margin: 0.5rem 0;
  color: #34495e;
  line-height: 1.6;
}

.resource-detail .content {
  background-color: #f9f9f9;
  padding: 1rem;
  border-radius: 8px;
  margin-top: 1rem;
  white-space: pre-wrap;
  font-size: 1rem;
  color: #333;
}

.comments {
  margin-top: 3rem;
}

.comments h2 {
  font-size: 1.4rem;
  color: #2c3e50;
  margin-bottom: 1rem;
  border-bottom: 2px solid #eee;
  padding-bottom: 0.5rem;
}

.comment {
  background-color: #f6f8fa;
  border-radius: 8px;
  padding: 1rem;
  margin-bottom: 1rem;
}

.comment .meta {
  font-size: 0.85rem;
  color: #7f8c8d;
  margin-bottom: 0.5rem;
}

.sub-comments {
  margin-left: 1.5rem;
  margin-top: 1rem;
}

.reply {
  margin-top: 1rem;
}

.heading {
  display: flex;
  align-items: center;
  gap: 12px;
}

.badge-exploited {
  display: inline-block;
  margin: 0.5rem 0;
  padding: 2px 8px;
  border-radius: 6px;
  background: #10b981;     
  color: #fff;
  font-size: .75rem;
  font-weight: 600;
}
</style>
