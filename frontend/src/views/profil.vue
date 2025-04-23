<template>
  <div class="profile-container">
    <n-card :hoverable="true" class="profile-card">
      <n-space align="center">
        <n-avatar round size="100" src="https://randomuser.me/api/portraits/men/1.jpg" />

        <div class="profile-info">
          <p><strong>Nom :</strong> Doe</p>
          <p><strong>Prénom :</strong> John</p>
          <p><strong>Email :</strong> john.doe@example.com</p>
          <p><strong>Date inscription :</strong> 11/04/2025</p>
          <p><strong>Mot de passe :</strong> ********
            <n-button text @click="showPasswordModal">Modifier</n-button>
          </p>
        </div>
      </n-space>

      <n-space justify="center" style="margin-top: 20px;">
        <n-button type="primary" @click="editProfile">Modifier</n-button>
        <n-button @click="viewSettings">Paramètres</n-button>
      </n-space>
    </n-card>

    <n-card class="favorites-section" title="Ressources mises en favoris" style="margin-top: 20px;">
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
  </div>
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
  console.log('Modification du profil')
}

function viewSettings() {
  console.log('Ouverture des paramètres')
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
  // Exemple : this.$router.push({ name: 'resource-detail', params: { id } })
}
</script>

<style scoped>
.profile-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 40px 20px;
}

.profile-card {
  width: 500px;
  padding: 20px;
}

.profile-info {
  margin-left: 20px;
}

.profile-info p {
  margin: 5px 0;
}

.error {
  color: red;
  font-size: 14px;
}

.favorites-section,
.stats-section {
  width: 500px;
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
  display: inline-block;
  margin-top: 20px;
}
</style>