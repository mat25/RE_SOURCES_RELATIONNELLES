<template>
  <div class="profile-page">
    <div class="profile-header">
      <div class="cover-wrapper">
        <img :src="user.coverUrl || defaultCover" class="cover-image" />
        <input type="file" @change="updateCover" class="upload-cover" />
      </div>

      <div class="avatar-wrapper">
        <n-avatar :size="100" round :src="user.avatarUrl || defaultAvatar" />
        <input type="file" @change="updateAvatar" class="upload-avatar" />
      </div>

      <h2 class="profile-name">{{ user.firstName }} {{ user.name }}</h2>
    </div>

    <n-card class="profile-card" title="Informations personnelles" hoverable>
      <template v-if="!editingProfile">
        <p><strong>Nom :</strong> {{ user.name }}</p>
        <p><strong>Prénom :</strong> {{ user.firstName }}</p>
        <p><strong>Email :</strong> {{ user.email }}</p>
        <n-space justify="space-between">
          <n-button type="primary" @click="editingProfile = true">Modifier</n-button>
          <n-button tertiary @click="showPasswordModal = true">Changer mot de passe</n-button>
        </n-space>
      </template>
      <template v-else>
        <n-form @submit.prevent="saveProfile">
          <n-form-item label="Nom"><n-input v-model:value="edited.name" /></n-form-item>
          <n-form-item label="Prénom"><n-input v-model:value="edited.firstName" /></n-form-item>
          <n-form-item label="Email"><n-input v-model:value="edited.email" /></n-form-item>
          <n-space>
            <n-button type="primary" @click="saveProfile">Enregistrer</n-button>
            <n-button @click="cancelEdit">Annuler</n-button>
          </n-space>
        </n-form>
      </template>
    </n-card>

    <n-card class="section-card" title="Ressources mises en favoris">
      <div class="scroll-container">
        <n-space vertical>
          <n-card v-for="r in favorites" :key="r.id" class="resource-card">
            <h3 class="resource-title">{{ r.title }}</h3>
            <p>{{ r.description }}</p>
            <n-button @click="viewResource(r.id)">Voir</n-button>
          </n-card>
        </n-space>
      </div>
    </n-card>

    <n-card class="section-card" title="Ressources exploitées">
      <div class="scroll-container">
        <n-space vertical>
          <n-card v-for="r in exploited" :key="r.id" class="resource-card">
            <h3 class="resource-title">{{ r.title }}</h3>
            <p>{{ r.description }}</p>
            <n-button @click="viewResource(r.id)">Voir</n-button>
          </n-card>
        </n-space>
      </div>
    </n-card>

    <n-modal
  v-model:show="showPasswordModal"
  preset="dialog"
  class="password-modal"
  title="Changer le mot de passe"
>
  <n-form
    :model="passwordForm"
    label-placement="top"
    class="password-form"
    @submit.prevent="changePassword"
  >
    <n-form-item label="Mot de passe actuel" path="current">
      <n-input v-model:value="passwordForm.current" type="password" placeholder="Mot de passe actuel" />
    </n-form-item>

    <n-form-item label="Nouveau mot de passe" path="new">
      <n-input v-model:value="passwordForm.new" type="password" placeholder="Nouveau mot de passe" />
    </n-form-item>

    <n-form-item label="Confirmation" path="confirm">
      <n-input v-model:value="passwordForm.confirm" type="password" placeholder="Confirmer le mot de passe" />
    </n-form-item>

    <n-space justify="end" size="large">
      <n-button @click="showPasswordModal = false">Annuler</n-button>
      <n-button type="primary" attr-type="submit">Changer</n-button>
    </n-space>
  </n-form>
</n-modal>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'
import { useRouter } from 'vue-router'
import { useMessage } from 'naive-ui'

const router = useRouter()
const message = useMessage()

const user = ref({})
const edited = ref({})
const favorites = ref([])
const exploited = ref([])
const editingProfile = ref(false)
const showPasswordModal = ref(false)

const passwordForm = ref({
  current: '',
  new: '',
  confirm: ''
})

const defaultAvatar = 'https://i.pravatar.cc/100'
const defaultCover = '/images/default-cover.jpg'

const api = axios.create({
  baseURL: '/api',
  headers: {
    Authorization: `Bearer ${localStorage.getItem('jwt_token')}`
  }
})

async function loadUser() {
  try {
    const [u, fav, exp] = await Promise.all([
      api.get('/users/me'),
      api.get('/resources/favorites'),
      api.get('/resources/exploited')
    ])
    user.value = u.data
    edited.value = { ...u.data }
    favorites.value = fav.data
    exploited.value = exp.data
  } catch (e) {
    console.error('Erreur chargement', e)
  }
}

function updateAvatar(event) {
  const file = event.target.files[0]
  if (!file) return
  const formData = new FormData()
  formData.append('file', file)
  api.post('/users/avatar', formData).then(loadUser)
}

function updateCover(event) {
  const file = event.target.files[0]
  if (!file) return
  const formData = new FormData()
  formData.append('file', file)
  api.post('/users/cover', formData).then(loadUser)
}

function saveProfile() {
  api.patch('/users/me', edited.value).then(res => {
    user.value = res.data
    editingProfile.value = false
  })
}

function cancelEdit() {
  edited.value = { ...user.value }
  editingProfile.value = false
}

function viewResource(id) {
  router.push(`/resources/${id}`)
}

function changePassword() {
  if (passwordForm.value.new !== passwordForm.value.confirm) {
    message.error('Les mots de passe ne correspondent pas.')
    return
  }

  api.post('/users/change-password', {
    currentPassword: passwordForm.value.current,
    newPassword: passwordForm.value.new
  })
    .then(() => {
      message.success('Mot de passe changé !')
      showPasswordModal.value = false
      passwordForm.value = { current: '', new: '', confirm: '' }
    })
    .catch(() => {
      message.error('Erreur lors du changement de mot de passe')
    })
}

onMounted(loadUser)
</script>

<style scoped>
.profile-page {
  margin: auto;
  padding: 40px 20px;
  background-color: #f4f6f9;
}

.profile-header {
  text-align: center;
  margin-bottom: 40px;
  position: relative;
}

.cover-wrapper {
  height: 200px;
  border-radius: 12px;
  overflow: hidden;
  position: relative;
}

.cover-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.upload-cover,
.upload-avatar {
  position: absolute;
  cursor: pointer;
  opacity: 0.8;
  background: white;
  padding: 4px;
  border-radius: 6px;
  font-size: 12px;
}

.upload-cover {
  top: 10px;
  right: 10px;
}

.avatar-wrapper {
  position: absolute;
  top: 130px;
  left: 50%;
  transform: translateX(-50%);
}

.upload-avatar {
  bottom: -10px;
  right: -10px;
}

.profile-name {
  margin-top: 70px;
  font-size: 24px;
  font-weight: bold;
}

.profile-card,
.section-card {
  margin-top: 20px;
  background-color: white;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
  padding: 24px;
}

.resource-card {
  margin-bottom: 12px;
  border: 1px solid #eee;
  border-radius: 8px;
  padding: 12px;
  background: #fff;
}
.profile-page {
  margin: auto;
  padding: 40px 20px;
  background-color: #f4f6f9;
  max-width: 900px;
}

.profile-header {
  text-align: center;
  margin-bottom: 40px;
  position: relative;
}

.cover-wrapper {
  height: 200px;
  border-radius: 12px;
  overflow: hidden;
  position: relative;
}

.cover-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.upload-cover,
.upload-avatar {
  position: absolute;
  cursor: pointer;
  opacity: 0.8;
  background: white;
  padding: 4px;
  border-radius: 6px;
  font-size: 12px;
}

.upload-cover {
  top: 10px;
  right: 10px;
}

.avatar-wrapper {
  position: absolute;
  top: 130px;
  left: 50%;
  transform: translateX(-50%);
}

.upload-avatar {
  bottom: -10px;
  right: -10px;
}

.profile-name {
  margin-top: 70px;
  font-size: 24px;
  font-weight: bold;
}

.profile-card,
.section-card {
  margin-top: 20px;
  background-color: white;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
  padding: 24px;
}

.resource-card {
  margin-bottom: 12px;
  border: 1px solid #eee;
  border-radius: 8px;
  padding: 12px;
  background: #fff;
}

.resource-title {
  font-size: 18px;
  font-weight: 600;
  margin-bottom: 6px;
}

.scroll-container {
  max-height: 300px;
  overflow-y: auto;
  padding-right: 4px;
}


</style>
