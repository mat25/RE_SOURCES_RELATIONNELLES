<template>
  <div class="back-office">
    <div class="section-container">
      <div class="section-box">
        <h2 class="section-title">Utilisateurs</h2>
        <div class="search-filter">
          <input type="text" v-model="searchUsers" placeholder="Rechercher des utilisateurs">
          <select v-model="sortUsersBy">
            <option value="name">Nom</option>
            <option value="role">Rôle</option>
            <option value="email">Email</option>
          </select>
          <select v-model="filterUsersByRole">
            <option value="">Tous les rôles</option>
            <option value="Admin">Admin</option>
            <option value="Modérateur">Modérateur</option>
            <option value="Super Admin">Super Admin</option>
          </select>
        </div>
        <div class="item-list scrollable">
          <div v-for="(user, index) in filteredAndSortedUsers" :key="index" class="item">
            <div class="user-card">
              <p class="user-name"><strong>{{ user.name }}</strong> ({{ user.role }})</p>
              <p>Email: {{ user.email }}</p>
              <button class="action-button" @click="deleteUser(user)">Supprimer</button>
            </div>
          </div>
        </div>
        <div class="pagination">
          <button class="pagination-button" @click="changePage('users', 'prev')" :disabled="currentUserPage === 1">Précédent</button>
          <span>Page {{ currentUserPage }} sur {{ totalUserPages }}</span>
          <button class="pagination-button" @click="changePage('users', 'next')" :disabled="currentUserPage === totalUserPages">Suivant</button>
        </div>
      </div>

      <div class="section-box">
        <h2 class="section-title">Catégories</h2>
        <div class="search-filter">
          <input type="text" v-model="searchCategories" placeholder="Rechercher des catégories">
          <select v-model="sortCategoriesBy">
            <option value="name">Nom</option>
            <option value="description">Description</option>
          </select>
        </div>
        <div class="item-list scrollable">
          <div v-for="(category, index) in filteredAndSortedCategories" :key="index" class="item">
            <div class="category-card">
              <p><strong>{{ category.name }}</strong></p>
              <p>{{ category.description }}</p>
              <button class="action-button" @click="deleteCategory(category)">Supprimer</button>
            </div>
          </div>
        </div>
        <div class="pagination">
          <button class="pagination-button" @click="changePage('categories', 'prev')" :disabled="currentCategoryPage === 1">Précédent</button>
          <span>Page {{ currentCategoryPage }} sur {{ totalCategoryPages }}</span>
          <button class="pagination-button" @click="changePage('categories', 'next')" :disabled="currentCategoryPage === totalCategoryPages">Suivant</button>
        </div>
      </div>

      <div class="section-box">
        <h2 class="section-title">Ressources</h2>
        <div class="search-filter">
          <input type="text" v-model="searchResources" placeholder="Rechercher des ressources">
          <select v-model="sortResourcesBy">
            <option value="name">Nom</option>
            <option value="type">Type</option>
            <option value="createdAt">Date de création</option>
          </select>
        </div>
        <div class="item-list scrollable">
          <div v-for="(resource, index) in filteredAndSortedResources" :key="index" class="item">
            <div class="resource-card">
              <p><strong>{{ resource.name }}</strong> ({{ resource.type }})</p>
              <p>Créé le: {{ resource.createdAt }}</p>
              <button class="action-button" @click="deleteResource(resource)">Supprimer</button>
            </div>
          </div>
        </div>
        <div class="pagination">
          <button class="pagination-button" @click="changePage('resources', 'prev')" :disabled="currentResourcePage === 1">Précédent</button>
          <span>Page {{ currentResourcePage }} sur {{ totalResourcePages }}</span>
          <button class="pagination-button" @click="changePage('resources', 'next')" :disabled="currentResourcePage === totalResourcePages">Suivant</button>
        </div>
      </div>
    </div>

    <div class="section-box" style="width: 100%;">
      <h2 class="section-title">Statistiques</h2>
      <div class="stats-container">
        <div class="stats-row">
          <div class="stats-chart-container">
            <h3>Graphique des utilisateurs par rôle</h3>
            <BarChart :data="userRolesData" :options="chartOptions" />
          </div>
          <div class="stats-chart-container">
            <h3>Consultations</h3>
            <div class="chart-controls">
              <button @click="selectedChart = 'week'" :class="{ active: selectedChart === 'week' }">Semaine</button>
              <button @click="selectedChart = 'month'" :class="{ active: selectedChart === 'month' }">Mois</button>
              <button @click="selectedChart = 'year'" :class="{ active: selectedChart === 'year' }">Année</button>
            </div>
            <v-chart :option="chartOption" style="height: 300px; width: 100%;" />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { Bar } from "vue-chartjs";
import { Chart as ChartJS, LinearScale, CategoryScale, BarElement, Title, Tooltip, Legend } from "chart.js";
import { computed, defineComponent, ref } from "vue";
import VChart from 'vue-echarts';
import { use } from 'echarts/core';
import { LineChart, BarChart as EBarChart } from 'echarts/charts';
import {
  TitleComponent,
  TooltipComponent,
  GridComponent,
  LegendComponent
} from 'echarts/components';
import { CanvasRenderer } from 'echarts/renderers';

ChartJS.register(LinearScale, CategoryScale, BarElement, Title, Tooltip, Legend);

use([
  LineChart,
  EBarChart,
  TitleComponent,
  TooltipComponent,
  GridComponent,
  LegendComponent,
  CanvasRenderer
]);

export default defineComponent({
  components: {
    BarChart: Bar,
    VChart
  },
  data() {
    return {
      users: [
        { name: "Alice", role: "Admin", email: "alice@example.com" },
        { name: "Bob", role: "Modérateur", email: "bob@example.com" },
        { name: "Charlie", role: "Super Admin", email: "charlie@example.com" },
        { name: "David", role: "Admin", email: "david@example.com" },
        { name: "Eve", role: "Modérateur", email: "eve@example.com" }
      ],
      categories: [
        { name: "Technologie", description: "Catégorie sur les dernières technologies" },
        { name: "Sport", description: "Catégorie sur le sport et l'exercice physique" },
        { name: "Santé", description: "Catégorie sur la santé et le bien-être" },
        { name: "Éducation", description: "Catégorie sur l'éducation et l'apprentissage" }
      ],
      resources: [
        { name: "Document A", type: "PDF", createdAt: "2025-04-22" },
        { name: "Document B", type: "Word", createdAt: "2025-04-21" },
        { name: "Document C", type: "Excel", createdAt: "2025-04-20" },
        { name: "Document D", type: "PowerPoint", createdAt: "2025-04-19" }
      ],
      currentUserPage: 1,
      usersPerPage: 2,
      currentCategoryPage: 1,
      categoriesPerPage: 2,
      currentResourcePage: 1,
      resourcesPerPage: 2,
      selectedChart: 'week',
      weekChart: {
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
      },
      monthChart: {
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
      },
      yearChart: {
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
      },
      searchUsers: '',
      sortUsersBy: 'name',
      filterUsersByRole: '',
      searchCategories: '',
      sortCategoriesBy: 'name',
      searchResources: '',
      sortResourcesBy: 'name',
    };
  },
  computed: {
    totalUserPages() {
      return Math.ceil(this.filteredUsers.length / this.usersPerPage);
    },
    paginatedUsers() {
      const start = (this.currentUserPage - 1) * this.usersPerPage;
      const end = start + this.usersPerPage;
      return this.filteredAndSortedUsers.slice(start, end);
    },
    filteredUsers() {
      return this.users.filter(user => {
        const searchMatch =
            user.name.toLowerCase().includes(this.searchUsers.toLowerCase()) ||
            user.email.toLowerCase().includes(this.searchUsers.toLowerCase());
        const roleMatch = this.filterUsersByRole === '' || user.role === this.filterUsersByRole;
        return searchMatch && roleMatch;
      });
    },
    filteredAndSortedUsers() {
      const sortedUsers = [...this.filteredUsers].sort((a, b) => {
        if (this.sortUsersBy === 'name') return a.name.localeCompare(b.name);
        if (this.sortUsersBy === 'role') return a.role.localeCompare(b.role);
        if (this.sortUsersBy === 'email') return a.email.localeCompare(b.email);
        return 0;
      });
      return sortedUsers;
    },
    totalCategoryPages() {
      return Math.ceil(this.filteredCategories.length / this.categoriesPerPage);
    },
    paginatedCategories() {
      const start = (this.currentCategoryPage - 1) * this.categoriesPerPage;
      const end = start + this.categoriesPerPage;
      return this.filteredAndSortedCategories.slice(start, end);
    },
    filteredCategories() {
      return this.categories.filter(category =>
          category.name.toLowerCase().includes(this.searchCategories.toLowerCase()) ||
          category.description.toLowerCase().includes(this.searchCategories.toLowerCase())
      );
    },
    filteredAndSortedCategories() {
      const sortedCategories = [...this.filteredCategories].sort((a, b) => {
        if (this.sortCategoriesBy === 'name') return a.name.localeCompare(b.name);
        if (this.sortCategoriesBy === 'description') return a.description.localeCompare(b.description);
        return 0;
      });
      return sortedCategories;
    },
    totalResourcePages() {
      return Math.ceil(this.filteredResources.length / this.resourcesPerPage);
    },
    paginatedResources() {
      const start = (this.currentResourcePage - 1) * this.resourcesPerPage;
      const end = start + this.resourcesPerPage;
      return this.filteredAndSortedResources.slice(start, end);
    },
    filteredResources() {
      return this.resources.filter(resource =>
          resource.name.toLowerCase().includes(this.searchResources.toLowerCase()) ||
          resource.type.toLowerCase().includes(this.searchResources.toLowerCase()) ||
          resource.createdAt.toLowerCase().includes(this.searchResources.toLowerCase())
      );
    },
    filteredAndSortedResources() {
      const sortedResources = [...this.filteredResources].sort((a, b) => {
        if (this.sortResourcesBy === 'name') return a.name.localeCompare(b.name);
        if (this.sortResourcesBy === 'type') return a.type.localeCompare(b.type);
        if (this.sortResourcesBy === 'createdAt') return new Date(a.createdAt) - new Date(b.createdAt);
        return 0;
      });
      return sortedResources;
    },
    userRolesData() {
      const roleCounts = { Admin: 0, Modérateur: 0, "Super Admin": 0 };
      this.users.forEach(user => {
        roleCounts[user.role]++;
      });
      return {
        labels: ["Admin", "Modérateur", "Super Admin"],
        datasets: [
          {
            label: "Nombre d'utilisateurs",
            data: [
              roleCounts.Admin,
              roleCounts.Modérateur,
              roleCounts["Super Admin"]
            ],
            backgroundColor: ["#FF6384", "#36A2EB", "#FFCE56"],
            borderColor: ["#FF6384", "#36A2EB", "#FFCE56"],
            borderWidth: 1
          }
        ]
      };
    },
    chartOptions() {
      return {
        responsive: true,
        scales: {
          y: {
            beginAtZero: true
          }
        }
      };
    },
    chartOption() {
      if (this.selectedChart === 'month') return this.monthChart;
      if (this.selectedChart === 'year') return this.yearChart;
      return this.weekChart;
    }
  },
  methods: {
    changePage(section, direction) {
      if (section === 'users') {
        this.currentUserPage = direction === 'next' ? this.currentUserPage + 1 : this.currentUserPage - 1;
      } else if (section === 'categories') {
        this.currentCategoryPage = direction === 'next' ? this.currentCategoryPage + 1 : this.currentCategoryPage - 1;
      } else if (section === 'resources') {
        this.currentResourcePage = direction === 'next' ? this.currentResourcePage + 1 : this.currentResourcePage - 1;
      }
    },
    deleteUser(user) {
      this.users = this.users.filter(u => u !== user);
    },
    deleteCategory(category) {
      this.categories = this.categories.filter(c => c !== category);
    },
    deleteResource(resource) {
      this.resources = this.resources.filter(r => r !== resource);
    }
  }
});
</script>

<style scoped>
.back-office {
  font-family: Arial, sans-serif;
  margin: 20px;
  color: #333; /* Couleur de police par défaut */
}

.section-title {
  font-size: 24px;
  margin-bottom: 15px;
  color: #333;
  border-bottom: 2px solid #ccc;
  padding-bottom: 8px;
}

.section-container {
  display: flex;
  flex-wrap: wrap;
  gap: 20px;
  margin-bottom: 20px;
}

.section-box {
  background-color: #f9f9f9;
  border-radius: 8px;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
  padding: 15px;
  width: calc(50% - 10px);
  min-width: 350px; /* Augmentation de la largeur minimale pour accueillir les filtres */
}

.stats-container {
  background-color: #f4f4f4;
  border-radius: 8px;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
  padding: 15px;
  width: 100%;
}

.stats-row {
  display: flex;
  gap: 20px; /* Espacement entre les deux graphiques */
  flex-wrap: wrap; /* Permet aux graphiques de passer à la ligne sur les écrans plus petits */
}

.stats-chart-container {
  flex: 1; /* Chaque conteneur de graphique prend une part égale de l'espace */
  min-width: 300px; /* Largeur minimale pour chaque graphique */
}

.chart-controls {
  display: flex;
  gap: 10px;
  margin-bottom: 10px;
  justify-content: center;
}

.chart-controls button {
  padding: 8px 15px;
  border: 1px solid #ccc;
  border-radius: 4px;
  cursor: pointer;
  background-color: white;
  font-size: 14px;
  color: #333;
}

.chart-controls button.active {
  background-color: #2196f3;
  color: white;
  border-color: #2196f3;
}

.item-list {
  margin-top: 10px;
}

.scrollable {
  max-height: 300px; /* Hauteur maximale avant le défilement */
  overflow-y: auto; /* Ajoute un scroll vertical si nécessaire */
  padding-right: 5px; /* Pour éviter que le contenu ne soit caché par la barre de défilement */
}

.item {
  margin-bottom: 10px;
  padding: 10px;
  background-color: white;
  border-radius: 4px;
  border: 1px solid #eee;
}

.user-card p,
.category-card p,
.resource-card p {
  font-size: 14px;
  margin-bottom: 5px;
  color: #333; /* Couleur de police du texte des cartes */
}

.action-button {
  background-color: #f44336;
  color: white;
  border: none;
  padding: 8px 15px;
  border-radius: 4px;
  cursor: pointer;
  transition: background-color 0.3s ease;
  font-size: 14px;
  margin-top: 5px;
}

.action-button:hover {
  background-color: #d32f2f;
}

.pagination {
  margin-top: 15px;
  display: flex;
  justify-content: center;
  align-items: center;
}

.pagination-button {
  padding: 8px 15px;
  background-color: #2196f3;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  transition: background-color 0.3s ease;
  font-size: 14px;
  margin: 0 5px;
}

.pagination-button:hover {
  background-color: #1976d2;
}

.search-filter {
  display: flex;
  gap: 10px;
  margin-bottom: 10px;
  align-items: center;
}

.search-filter input[type="text"],
.search-filter select {
  padding: 8px;
  border: 1px solid #ccc;
  border-radius: 4px;
  font-size: 14px;
}
</style>