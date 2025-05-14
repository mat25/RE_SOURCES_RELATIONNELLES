<template>
  <div class="cover-photo">
    <img src="https://images.unsplash.com/photo-1503264116251-35a269479413" alt="cover" />
    <n-avatar
      class="profile-avatar"
      round
      size="100"
      src="https://randomuser.me/api/portraits/men/1.jpg"
    />
  </div>

  <div class="profile-container">
    <!-- Colonne gauche : Infos utilisateur -->
    <div class="left-column">
      <n-card :hoverable="true" class="profile-card">
        <h2>Profil</h2>
        <div class="profile-info" v-if="!editingProfile">
          <p><strong>Nom :</strong> {{ user.name }}</p>
          <p><strong>Prénom :</strong> {{ user.firstName }}</p>
          <p><strong>Email :</strong> {{ user.email }}</p>
          <p><strong>Date inscription :</strong> 11/04/2025</p>
          <p><strong>Mot de passe :</strong> ********
            <n-button text @click="showPasswordModal">Modifier</n-button>
          </p>
        </div>

        <!-- Formulaire de modification de profil -->
        <div v-if="editingProfile">
          <n-form @submit.prevent="saveProfileChanges">
            <n-form-item label="Nom">
              <n-input v-model="user.name" placeholder="Entrez votre nom" />
            </n-form-item>
            <n-form-item label="Prénom">
              <n-input v-model="user.firstName" placeholder="Entrez votre prénom" />
            </n-form-item>
            <n-form-item label="Email">
              <n-input v-model="user.email" placeholder="Entrez votre email" />
            </n-form-item>
            <n-space justify="center">
              <n-button type="primary" @click="saveProfileChanges">Enregistrer</n-button>
              <n-button @click="cancelEditProfile">Annuler</n-button>
            </n-space>
          </n-form>
        </div>

        <n-space justify="center" style="margin-top: 20px;">
          <n-button type="primary" @click="editProfile">Modifier</n-button>
          <n-button @click="viewSettings">Paramètres</n-button>
        </n-space>
      </n-card>
    </div>

    <!-- Colonne droite : Favoris + Stats -->
    <div class="right-column">
      <n-card class="favorites-section" title="Ressources mises en favoris">
        <n-space vertical>
          <n-card v-for="resource in favoriteResources" :key="resource.id" class="resource-card">
            <h3>{{ resource.title }}</h3>
            <p>{{ resource.description }}</p>
            <n-button type="info" @click="goToResource(resource.id)">Voir la ressource</n-button>
          </n-card>
        </n-space>
      </n-card>

      <n-card class="stats-section" title="Statistiques" style="margin-top: 20px;">
        <n-space justify="center" class="n-button-group">
          <n-button @click="selectedChart = 'week'">Semaine</n-button>
          <n-button @click="selectedChart = 'month'">Mois</n-button>
          <n-button @click="selectedChart = 'year'">Année</n-button>
        </n-space>
        <div class="stats-container">
          <v-chart :option="chartOption" style="height: 300px; width: 100%;" />
        </div>
      </n-card>
    </div>
  </div>

  <!-- Modal pour changer le mot de passe -->
  <n-modal v-model:show="showModal" preset="card" title="Modifier le mot de passe">
    <n-form @submit.prevent="changePassword">
      <n-form-item label="Votre ancien mot de passe">
        <n-input type="password" v-model="lastPassword" placeholder="Entrez votre ancien mot de passe" />
      </n-form-item>
      <n-form-item label="Nouveau mot de passe">
        <n-input type="password" v-model="newPassword" placeholder="Entrez un nouveau mot de passe" />
      </n-form-item>
      <n-form-item label="Confirmer le mot de passe">
        <n-input type="password" v-model="confirmPassword" placeholder="Confirmez le mot de passe" />
      </n-form-item>
      <p v-if="passwordError" class="error">{{ passwordError }}</p>
      <n-space justify="end">
        <n-button @click="showModal = false">Annuler</n-button>
        <n-button type="primary" @click="changePassword">Enregistrer</n-button>
      </n-space>
    </n-form>
  </n-modal>
</template>

<script setup>
import { ref, computed } from 'vue'
import VChart from 'vue-echarts'
import { use } from 'echarts/core'
import { LineChart, BarChart } from 'echarts/charts'
import {
  TitleComponent,
  TooltipComponent,
  GridComponent,
  LegendComponent
} from 'echarts/components'
import { CanvasRenderer } from 'echarts/renderers'

use([
  LineChart,
  BarChart,
  TitleComponent,
  TooltipComponent,
  GridComponent,
  LegendComponent,
  CanvasRenderer
])

const showModal = ref(false)
const lastPassword = ref('')
const newPassword = ref('')
const confirmPassword = ref('')
const passwordError = ref('')
const selectedChart = ref('week')

const favoriteResources = ref([
  { id: 1, title: 'Ressource 1', description: 'Description de la ressource 1' },
  { id: 2, title: 'Ressource 2', description: 'Description de la ressource 2' }
])

const user = ref({
  name: 'Doe',
  firstName: 'John',
  email: 'john.doe@example.com'
})

const editingProfile = ref(false)

const weekChart = ref({
  tooltip: { trigger: 'axis' },
  xAxis: { type: 'category', data: ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'] },
  yAxis: { type: 'value' },
  series: [
    {
      name: 'Consultations',
      type: 'bar',
      data: [120, 132, 101, 134, 90, 230, 210]
    }
  ]
})

const monthChart = ref({
  tooltip: { trigger: 'axis' },
  xAxis: {
    type: 'category',
    data: Array.from({ length: 30 }, (_, i) => `Jour ${i + 1}`)
  },
  yAxis: { type: 'value' },
  series: [
    {
      name: 'Consultations',
      type: 'line',
      smooth: true,
      data: Array.from({ length: 30 }, () => Math.floor(Math.random() * 200) + 50)
    }
  ]
})

const yearChart = ref({
  tooltip: { trigger: 'axis' },
  xAxis: {
    type: 'category',
    data: ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin', 'Juil', 'Août', 'Sep', 'Oct', 'Nov', 'Déc']
  },
  yAxis: { type: 'value' },
  series: [
    {
      name: 'Consultations',
      type: 'bar',
      data: [820, 932, 901, 934, 1290, 1330, 1320, 1450, 1200, 1100, 950, 1230]
    }
  ]
})

const chartOption = computed(() => {
  if (selectedChart.value === 'month') return monthChart.value
  if (selectedChart.value === 'year') return yearChart.value
  return weekChart.value
})

function editProfile() {
  editingProfile.value = true
}

function cancelEditProfile() {
  editingProfile.value = false
}

function saveProfileChanges() {
  console.log('Modifications du profil sauvegardées', user.value)
  editingProfile.value = false
}

function showPasswordModal() {
  showModal.value = true
}

function changePassword() {
  if (!newPassword.value) {
    passwordError.value = 'Le mot de passe est requis.'
    return
  }
  if (newPassword.value.length < 6) {
    passwordError.value = 'Le mot de passe doit contenir au moins 6 caractères.'
    return
  }
  if (!/[A-Z]/.test(newPassword.value)) {
    passwordError.value = 'Le mot de passe doit contenir au moins une majuscule.'
    return
  }
  if (!/\d/.test(newPassword.value)) {
    passwordError.value = 'Le mot de passe doit contenir au moins un chiffre.'
    return
  }
  if (newPassword.value !== confirmPassword.value) {
    passwordError.value = 'Les mots de passe ne correspondent pas.'
    return
  }

  passwordError.value = ''
  showModal.value = false
  console.log('Mot de passe changé avec succès !')
}

function goToResource(id) {
  console.log('Redirection vers la ressource', id)
}
</script>

<style scoped>
.cover-photo {
  position: relative;
  width: 100%;
  height: 200px;
  border-radius: 8px;
  margin-bottom: 60px;
}

.cover-photo img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.profile-avatar {
  position: absolute;
  bottom: -50px;
  left: 50%;
  transform: translateX(-50%);
  border: 4px solid white;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.profile-container {
  display: flex;
  flex-direction: row;
  align-items: stretch; /* étire les enfants à la même hauteur */
  gap: 20px;
  padding: 40px 20px;
}

.left-column {
  flex: 0 0 300px;
}

.right-column {
  flex: 1;
  min-width: 300px;
}

.profile-card,
.favorites-section,
.stats-section {
  padding: 20px;
}

.profile-info p {
  margin: 5px 0;
}

.error {
  color: red;
  font-size: 14px;
}

.resource-card {
  margin-bottom: 10px;
}

.stats-container {
  min-height: 300px;
  display: flex;
  justify-content: center;
  align-items: center;
}

.n-button-group {
  margin-top: 10px;
}
</style>
