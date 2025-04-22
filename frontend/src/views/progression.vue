<template>
  <div class="container mx-auto py-8 px-4">
    <n-h2 class="text-center text-2xl font-semibold mb-8">
      Statistiques de Consultation
    </n-h2>

    <div class="mb-6 text-center">
      <n-button-group>
        <n-button
            @click="selectedChart = 'week'"
            :type="selectedChart === 'week' ? 'primary' : 'default'"
        >
          Semaine
        </n-button>
        <n-button
            @click="selectedChart = 'month'"
            :type="selectedChart === 'month' ? 'primary' : 'default'"
        >
          Mois
        </n-button>
        <n-button
            @click="selectedChart = 'year'"
            :type="selectedChart === 'year' ? 'primary' : 'default'"
        >
          Année
        </n-button>
      </n-button-group>
    </div>

    <!-- Affichage dynamique du graphique en fonction de la sélection -->
    <n-card v-if="selectedChart === 'week'" title="Consultations cette semaine" size="medium">
      <v-chart :option="weekChart" autoresize style="height: 300px;" />
    </n-card>

    <n-card v-if="selectedChart === 'month'" title="Consultations ce mois-ci" size="medium">
      <v-chart :option="monthChart" autoresize style="height: 300px;" />
    </n-card>

    <n-card v-if="selectedChart === 'year'" title="Consultations cette année" size="medium">
      <v-chart :option="yearChart" autoresize style="height: 300px;" />
    </n-card>
  </div>
</template>

<script setup>
import { ref } from 'vue'
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

// Enregistrer les composants nécessaires
use([
  LineChart,
  BarChart,
  TitleComponent,
  TooltipComponent,
  GridComponent,
  LegendComponent,
  CanvasRenderer
])

// État réactif pour le graphique sélectionné
const selectedChart = ref('week')

// 📅 Graphique de la semaine
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

// 📆 Graphique du mois
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

// 📊 Graphique de l’année
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
</script>

<style scoped>
.container {
  max-width: 1200px;
  margin: 0 auto;
}

.n-card {
  border-radius: 8px;
}

.n-button-group {
  display: inline-block;
  margin-top: 20px;
}
</style>
