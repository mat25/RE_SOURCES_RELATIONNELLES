<template>
  <div class="back-office">
    <div class="section-container">
      <div class="section-box">
        <h2 class="section-title">Utilisateurs</h2>
        <button class="create-button" @click="openCreateUserModal">Créer un utilisateur</button>
        <div class="search-filter">
          <input type="text" v-model="searchUsers" placeholder="Rechercher des utilisateurs">
          <select v-model="sortUsersBy">
            <option value="name">Nom</option>
            <option value="role">Rôle</option>
            <option value="email">Email</option>
            <option value="status">Statut</option>
          </select>
          <select v-model="filterUsersByRole">
            <option value="">Tous les rôles</option>
            <option value="Admin">Admin</option>
            <option value="Modérateur">Modérateur</option>
            <option value="Super Admin">Super Admin</option>
          </select>
          <select v-model="filterUsersByStatus">
            <option value="">Tous les statuts</option>
            <option value="Actif">Actif</option>
            <option value="Suspendu">Suspendu</option>
            <option value="Banni">Banni</option>
          </select>
        </div>
        <div class="item-list scrollable">
          <div v-for="(user, index) in filteredAndSortedUsers" :key="index" class="item">
            <div class="user-card">
              <p class="user-name"><strong>{{ user.name }}</strong> ({{ user.role }})</p>
              <p>Email: {{ user.email }}</p>
              <p>Statut: <span :class="userStatusClass(user.status)">{{ user.status }}</span> <span v-if="user.banDuration"> (pour {{ formatBanDuration(user.banDuration) }})</span></p>
              <div class="user-actions">
                <button v-if="user.status === 'Actif'" class="suspend-button" @click="openSuspendModal(user)">Suspendre</button>
                <button v-if="user.status === 'Actif'" class="ban-button" @click="openBanModal(user)">Bannir</button>
                <button v-if="user.status !== 'Actif'" class="activate-button" @click="activateUser(user)">Activer</button>
              </div>
            </div>
          </div>
        </div>
        <div class="pagination">
          <button class="pagination-button" @click="changePage('users', 'prev')" :disabled="currentUserPage === 1">Précédent</button>
          <span>Page {{ currentUserPage }} sur {{ totalUserPages }}</span>
          <button class="pagination-button" @click="changePage('users', 'next')" :disabled="currentUserPage === totalUserPages">Suivant</button>
        </div>
      </div>

      <div v-if="showSuspendModal" class="modal">
        <div class="modal-content">
          <span class="close-button" @click="closeSuspendModal">&times;</span>
          <h3>Suspendre l'utilisateur</h3>
          <p>Êtes-vous sûr de vouloir suspendre l'utilisateur <strong>{{ selectedUser ? selectedUser.name : '' }}</strong> ?</p>
          <button class="submit-button" @click="suspendUser">Suspendre</button>
          <button class="cancel-button" @click="closeSuspendModal">Annuler</button>
        </div>
      </div>

      <div v-if="showBanModal" class="modal">
        <div class="modal-content">
          <span class="close-button" @click="closeBanModal">&times;</span>
          <h3>Bannir l'utilisateur</h3>
          <p>Êtes-vous sûr de vouloir bannir l'utilisateur <strong>{{ selectedUser ? selectedUser.name : '' }}</strong> ?</p>
          <label for="ban-duration">Durée du bannissement (en secondes):</label>
          <input type="number" id="ban-duration" v-model="banDuration" min="1" required>
          <button class="submit-button" @click="banUser">Bannir</button>
          <button class="cancel-button" @click="closeBanModal">Annuler</button>
        </div>
      </div>

      <div class="section-box">
        <h2 class="section-title">Catégories</h2>
        <button class="create-button" @click="openCreateCategoryModal">Créer une catégorie</button>
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
        <button class="create-button" @click="openCreateResourceModal">Créer une ressource</button>
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
              <button v-if="resource.needsValidation" class="validate-button" @click="validateResource(resource)">Valider</button>
            </div>
          </div>
        </div>
        <div class="pagination">
          <button class="pagination-button" @click="changePage('resources', 'prev')" :disabled="currentResourcePage === 1">Précédent</button>
          <span>Page {{ currentResourcePage }} sur {{ totalResourcePages }}</span>
          <button class="pagination-button" @click="changePage('resources', 'next')" :disabled="currentResourcePage === totalResourcePages">Suivant</button>
        </div>
      </div>

      <div v-if="showCreateResourceModal" class="modal">
        <div class="modal-content">
          <span class="close-button" @click="closeCreateResourceModal">&times;</span>
          <h3>Créer une ressource</h3>
          <label for="new-resource-title">Titre*:</label>
          <input type="text" id="new-resource-title" v-model="newResource.title" required>

          <label for="new-resource-content">Contenu*:</label>
          <textarea id="new-resource-content" v-model="newResource.content" required></textarea>

          <label for="new-resource-image">Image*:</label>
          <input type="file" id="new-resource-image" @change="handleImageUpload" accept="image/*" required>
          <div v-if="newResource.imagePreview" class="image-preview">
            <img :src="newResource.imagePreview" alt="Aperçu de l'image" style="max-width: 100px; max-height: 100px;">
          </div>

          <label for="new-resource-category">Catégorie*:</label>
          <select id="new-resource-category" v-model="newResource.category" required>
            <option v-for="cat in categories" :key="cat.name" :value="cat.name">{{ cat.name }}</option>
            <option v-if="!categories.length" disabled>Aucune catégorie disponible</option>
          </select>

          <label>Visibilité:</label>
          <div class="radio-group">
            <input type="radio" id="public-resource" value="public" v-model="newResource.isPrivate">
            <label for="public-resource">Publique</label>
            <input type="radio" id="private-resource" value="private" v-model="newResource.isPrivate">
            <label for="private-resource">Privée</label>
          </div>

          <label for="new-resource-video-link">Lien vidéo (facultatif):</label>
          <input type="url" id="new-resource-video-link" v-model="newResource.videoLink">

          <button class="submit-button" @click="createResource">Créer</button>
        </div>
      </div>
    </div>

    <div class="section-box" style="width: 100%;">
      <h2 class="section-title">Statistiques</h2>
      <button class="export-stats-button" @click="exportStatistics">Exporter les statistiques</button>
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

    <div v-if="showCreateUserModal" class="modal">
      <div class="modal-content">
        <span class="close-button" @click="closeCreateUserModal">&times;</span>
        <h3>Créer un utilisateur</h3>
        <label for="new-user-name">Nom:</label>
        <input type="text" id="new-user-name" v-model="newUser.name">
        <label for="new-user-email">Email:</label>
        <input type="email" id="new-user-email" v-model="newUser.email">
        <label for="new-user-role">Rôle:</label>
        <select id="new-user-role" v-model="newUser.role">
          <option value="Modérateur">Modérateur</option>
          <option value="Admin">Admin</option>
          <option value="Super Admin">Super Admin</option>
        </select>
        <button class="submit-button" @click="createUser">Créer</button>
      </div>
    </div>

    <div v-if="showCreateCategoryModal" class="modal">
      <div class="modal-content">
        <span class="close-button" @click="closeCreateCategoryModal">&times;</span>
        <h3>Créer une catégorie</h3>
        <label for="new-category-name">Nom:</label>
        <input type="text" id="new-category-name" v-model="newCategory.name">
        <label for="new-category-description">Description:</label>
        <textarea id="new-category-description" v-model="newCategory.description"></textarea>
        <button class="submit-button" @click="createCategory">Créer</button>
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
        { name: "Alice", role: "Admin", email: "alice@example.com", status: 'Actif' },
        { name: "Bob", role: "Modérateur", email: "bob@example.com", status: 'Actif' },
        { name: "Charlie", role: "Super Admin", email: "charlie@example.com", status: 'Actif' },
        { name: "David", role: "Admin", email: "david@example.com", status: 'Suspendu' },
        { name: "Eve", role: "Modérateur", email: "eve@example.com", status: 'Banni', banDuration: 3600 }
      ],
      categories: [
        { name: "Technologie", description: "Catégorie sur les dernières technologies" },
        { name: "Sport", description: "Catégorie sur le sport et l'exercice physique" },
        { name: "Santé", description: "Catégorie sur la santé et le bien-être" },
        { name: "Éducation", description: "Catégorie sur l'éducation et l'apprentissage" }
      ],
      resources: [
        { name: "Document A", type: "PDF", createdAt: "2025-04-22" },
        { name: "Document B", type: "Word", createdAt: "2025-04-21", needsValidation: true }, // Exemple de ressource à valider
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
      filterUsersByStatus: '',
      searchCategories: '',
      sortCategoriesBy: 'name',
      searchResources: '',
      sortResourcesBy: 'name',
      showCreateUserModal: false,
      newUser: { name: '', email: '', role: 'Modérateur' },
      showCreateCategoryModal: false,
      newCategory: { name: '', description: '' },
      showCreateResourceModal: false,
      newResource: {
        title: '',
        content: '',
        image: null,
        imagePreview: null,
        category: '',
        isPrivate: 'public', // Par défaut publique
        videoLink: ''
      },
      showSuspendModal: false,
      showBanModal: false,
      selectedUser: null,
      banDuration: null
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
        const statusMatch = this.filterUsersByStatus === '' || user.status === this.filterUsersByStatus;
        return searchMatch && roleMatch && statusMatch;
      });
    },
    filteredAndSortedUsers() {
      const sortedUsers = [...this.filteredUsers].sort((a, b) => {
        if (this.sortUsersBy === 'name') return a.name.localeCompare(b.name);
        if (this.sortUsersBy === 'role') return a.role.localeCompare(b.role);
        if (this.sortUsersBy === 'email') return a.email.localeCompare(b.email);
        if (this.sortUsersBy === 'status') return a.status.localeCompare(b.status);
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
    userStatusClass(status) {
      if (status === 'Suspendu') return 'status-suspended';
      if (status === 'Banni') return 'status-banned';
      return 'status-active';
    },
    formatBanDuration(seconds) {
      const minutes = Math.floor(seconds / 60);
      return `${minutes} minute${minutes > 1 ? 's' : ''}`;
    },
    openSuspendModal(user) {
      this.selectedUser = user;
      this.showSuspendModal = true;
    },
    closeSuspendModal() {
      this.selectedUser = null;
      this.showSuspendModal = false;
    },
    suspendUser() {
      if (this.selectedUser) {
        this.selectedUser.status = 'Suspendu';
        this.closeSuspendModal();
      }
    },
    openBanModal(user) {
      this.selectedUser = user;
      this.banDuration = null;
      this.showBanModal = true;
    },
    closeBanModal() {
      this.selectedUser = null;
      this.banDuration = null;
      this.showBanModal = false;
    },
    banUser() {
      if (this.selectedUser && this.banDuration > 0) {
        this.selectedUser.status = 'Banni';
        this.selectedUser.banDuration = parseInt(this.banDuration);
        this.closeBanModal();
      } else {
        alert('Veuillez entrer une durée de bannissement valide.');
      }
    },
    activateUser(user) {
      user.status = 'Actif';
      user.banDuration = null;
    },
    openCreateUserModal() {
      this.showCreateUserModal = true;
      this.newUser = { name: '', email: '', role: 'Modérateur' }; // Réinitialise le formulaire
    },
    closeCreateUserModal() {
      this.showCreateUserModal = false;
    },
    createUser() {
      if (this.newUser.name && this.newUser.email && this.newUser.role) {
        this.users.push({ ...this.newUser, status: 'Actif' }); // Ajout du statut par défaut
        this.closeCreateUserModal();
      } else {
        alert('Veuillez remplir tous les champs pour créer un utilisateur.');
      }
    },
    openCreateCategoryModal() {
      this.showCreateCategoryModal = true;
      this.newCategory = { name: '', description: '' }; // Réinitialise le formulaire
    },
    closeCreateCategoryModal() {
      this.showCreateCategoryModal = false;
    },
    createCategory() {
      if (this.newCategory.name && this.newCategory.description) {
        this.categories.push({ ...this.newCategory });
        this.closeCreateCategoryModal();
      } else {
        alert('Veuillez remplir tous les champs pour créer une catégorie.');
      }
    },
    openCreateResourceModal() {
      this.showCreateResourceModal = true;
      this.newResource = {
        title: '',
        content: '',
        image: null,
        imagePreview: null,
        category: '',
        isPrivate: 'public',
        videoLink: ''
      };
    },
    closeCreateResourceModal() {
      this.showCreateResourceModal = false;
    },
    handleImageUpload(event) {
      const file = event.target.files[0];
      if (file) {
        this.newResource.image = file;
        this.newResource.imagePreview = URL.createObjectURL(file);
      } else {
        this.newResource.image = null;
        this.newResource.imagePreview = null;
      }
    },
    createResource() {
      if (this.newResource.title && this.newResource.content && this.newResource.image && this.newResource.category) {
        const newResource = {
          name: this.newResource.title, // Utiliser le titre comme nom pour l'affichage dans la liste
          type: this.newResource.image ? this.newResource.image.type : 'unknown', // Simuler le type
          createdAt: new Date().toLocaleDateString(),
          isPrivate: this.newResource.isPrivate === 'private',
          videoLink: this.newResource.videoLink,
          needsValidation: true // Simuler une ressource créée par un utilisateur nécessitant validation
        };
        this.resources.push(newResource);
        this.closeCreateResourceModal();
        // Ici, dans une application réelle, tu devrais envoyer les données à ton backend.
      } else {
        alert('Veuillez remplir tous les champs obligatoires.');
      }
    },
    validateResource(resource) {
      resource.needsValidation = false;
      alert(`La ressource "${resource.name}" a été validée et est maintenant publique.`);
      // Ici, tu mettrais à jour l'état de la ressource dans ta base de données.
    },
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
      // Suppression de l'ancienne logique de suppression
      console.warn('La suppression des utilisateurs est désactivée. Utilisez la suspension ou le bannissement.');
    },
    deleteCategory(category) {
      this.categories = this.categories.filter(c => c !== category);
    },
    deleteResource(resource) {
      this.resources = this.resources.filter(r => r !== resource);
    },

    exportStatistics() {
      const userRolesHeader = ["Rôle", "Nombre d'utilisateurs"];
      const userRolesDataRows = this.userRolesData.labels.map((label, index) => [
        label,
        this.userRolesData.datasets[0].data[index],
      ]);
      const userRolesCSV = [userRolesHeader, ...userRolesDataRows]
          .map((row) => row.join(','))
          .join('\n');

      const consultationChartData = this.chartOption.series[0].data;
      const consultationChartLabels = this.chartOption.xAxis.data;
      const consultationHeader = ["Période", "Consultations"];
      const consultationDataRows = consultationChartLabels.map((label, index) => [
        label,
        consultationChartData[index],
      ]);
      const consultationCSV = [consultationHeader, ...consultationDataRows]
          .map((row) => row.join(','))
          .join('\n');

      const combinedCSV = "Statistiques des utilisateurs par rôle:\n" + userRolesCSV + "\n\nStatistiques des consultations (" + this.selectedChart + "):\n" + consultationCSV;
      this.downloadFile(combinedCSV, "statistiques.csv", "text/csv;charset=utf-8;");
    },

    downloadFile(data, filename, mimeType) {
      const blob = new Blob([data], { type: mimeType });
      const url = window.URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = filename;
      document.body.appendChild(a);
      a.click();
      document.body.removeChild(a);
      window.URL.revokeObjectURL(url);
    }
  }
});
</script>
<style scoped>
.back-office {
  font-family: 'Segoe UI', Roboto, sans-serif;
  margin: 20px;
  color: #2c2c2c;
  background-color: #f4f6f8;
}

.section-title {
  font-size: 26px;
  margin-bottom: 20px;
  color: #005ea8;
  border-bottom: 2px solid #005ea8;
  padding-bottom: 6px;
  font-weight: 600;
}

.section-container {
  display: flex;
  flex-wrap: wrap;
  gap: 24px;
  margin-bottom: 30px;
}

.section-box {
  background-color: #ffffff;
  border-left: 4px solid #005ea8;
  border-radius: 8px;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
  padding: 20px;
  flex: 1 1 45%;
  min-width: 350px;
}

.stats-container {
  background-color: #ffffff;
  border-radius: 8px;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
  padding: 20px;
}

.stats-row {
  display: flex;
  gap: 20px;
  flex-wrap: wrap;
}

.stats-chart-container {
  flex: 1;
  min-width: 320px;
}

.chart-controls {
  display: flex;
  justify-content: center;
  gap: 12px;
  margin-bottom: 15px;
}

.chart-controls button {
  padding: 8px 18px;
  border: 1px solid #ccc;
  border-radius: 6px;
  background-color: #fff;
  cursor: pointer;
  font-size: 14px;
  transition: all 0.3s ease;
}

.chart-controls button.active {
  background-color: #005ea8;
  color: white;
  border-color: #005ea8;
}

.item-list {
  margin-top: 10px;
}

.scrollable {
  max-height: 300px;
  overflow-y: auto;
  padding-right: 5px;
}

.item {
  margin-bottom: 12px;
  padding: 12px;
  background-color: #fafafa;
  border-radius: 6px;
  border: 1px solid #e0e0e0;
}

.user-card p,
.category-card p,
.resource-card p {
  font-size: 15px;
  margin-bottom: 6px;
}

.action-button {
  background-color: #d32f2f;
  color: white;
  border: none;
  padding: 8px 16px;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
}

.action-button:hover {
  background-color: #b71c1c;
}

.pagination {
  margin-top: 20px;
  display: flex;
  justify-content: center;
}

.pagination-button {
  padding: 8px 16px;
  background-color: #005ea8;
  color: white;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
}

.pagination-button:hover {
  background-color: #004a86;
}

.search-filter {
  display: flex;
  gap: 12px;
  margin-bottom: 15px;
  align-items: center;
}

.search-filter input,
.search-filter select {
  padding: 8px;
  border: 1px solid #bbb;
  border-radius: 4px;
  font-size: 14px;
}

.create-button {
  background-color: #007a33;
  color: white;
  border: none;
  padding: 10px 18px;
  border-radius: 4px;
  font-size: 14px;
}

.create-button:hover {
  background-color: #006228;
}

.modal {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.45);
  display: flex;
  justify-content: center;
  align-items: center;
}

.modal-content {
  background-color: white;
  padding: 25px;
  border-radius: 8px;
  width: 90%;
  max-width: 550px;
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.15);
  position: relative;
}

.close-button {
  position: absolute;
  top: 10px;
  right: 15px;
  font-size: 24px;
  color: #666;
  cursor: pointer;
}

.close-button:hover {
  color: black;
}

.modal-content input,
.modal-content textarea,
.modal-content select {
  width: 100%;
  padding: 8px;
  margin-bottom: 12px;
  border: 1px solid #ccc;
  border-radius: 4px;
}

.submit-button {
  background-color: #005ea8;
  color: white;
  border: none;
  padding: 10px 18px;
  border-radius: 4px;
  font-size: 15px;
  cursor: pointer;
}

.submit-button:hover {
  background-color: #004a86;
}

.validate-button {
  background-color: #007a33;
  color: white;
  padding: 8px 15px;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
}

.validate-button:hover {
  background-color: #006228;
}

.suspend-button {
  background-color: #ff9800;
  color: white;
}

.ban-button {
  background-color: #d32f2f;
  color: white;
}

.activate-button {
  background-color: #28a745;
  color: white;
}

.status-active {
  color: #28a745;
  font-weight: 600;
}

.status-suspended {
  color: #ff9800;
  font-weight: 600;
}

.status-banned {
  color: #d32f2f;
  font-weight: 600;
}
</style>
