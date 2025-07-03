<template>
  <div class="admin-dashboard">
   <h1>Tableau de bord Administrateur</h1>

    <hr>

    <section class="dashboard-section user-management">
      <h2>Gestion des Utilisateurs</h2>

      <div class="controls-bar">
        <input
          type="text"
          v-model="searchUsers"
          placeholder="Rechercher par nom ou email"
          class="search-input"
        />
        <select v-model="filterUsersByRole" class="filter-select">
          <option value="">Tous les rôles</option>
          <option value="USER">USER</option>
          <option value="MODERATOR">MODERATOR</option>
          <option value="ADMIN">ADMIN</option>
        </select>
        <select v-model="filterUsersByStatus" class="filter-select">
          <option value="">Tous les statuts</option>
          <option value="Actif">Actif</option>
          <option value="Désactivé">Désactivé</option>
          <option value="Banni">Banni</option>
        </select>
        <select v-model="sortUsersBy" class="sort-select">
          <option value="username">Trier par Nom</option>
          <option value="email">Trier par Email</option>
          <option value="role">Trier par Rôle</option>
          <option value="status">Trier par Statut</option>
        </select>
        <button @click="openCreateUserModal" class="add-button">Ajouter un utilisateur</button>
      </div>

      <div v-if="loadingUsers" class="loading-message">Chargement des utilisateurs...</div>
      <div v-else-if="userFetchError" class="error-message">{{ userFetchError }}</div>
      <div v-else-if="paginatedUsers.length === 0" class="no-data-message">Aucun utilisateur trouvé.</div>
      <table v-else class="data-table users-table">
        <thead>
          <tr>
            <th>Nom d'utilisateur</th>
            <th>Email</th>
            <th>Rôle</th>
            <th>Statut</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="user in paginatedUsers" :key="user.id">
            <td>{{ user.username }}</td>
            <td>{{ user.email }}</td>
            <td>{{ user.role ? user.role.name : 'N/A' }}</td>
            <td>
              <span :class="userStatusClass(user)">
                {{ user.status === 'INACTIVE' ? 'Désactivé' : (user.banDuration > 0 ? 'Banni' : 'Actif') }}
                <span v-if="user.banDuration">({{ formatBanDuration(user.banDuration) }})</span>
              </span>
            </td>
            <td class="actions">
              <button @click="openEditUserModal(user)" class="action-button edit">Modifier</button>
              <button
                @click="toggleUserStatus(user)"
                :class="['action-button', user.status === 'ACTIVE' ? 'deactivate' : 'activate']"
              >
                {{ user.status === 'ACTIVE' ? 'Désactiver' : 'Activer' }}
              </button>

              <button @click="deleteUser(user)" class="action-button delete">Supprimer</button>
            </td>
          </tr>
        </tbody>
      </table>

      <div class="pagination">
        <button @click="changePage('users', 'prev')" :disabled="currentUserPage <= 1">Précédent</button>
        <span>Page {{ currentUserPage }} sur {{ totalUserPages }}</span>
        <button @click="changePage('users', 'next')" :disabled="currentUserPage >= totalUserPages">Suivant</button>
      </div>
    </section>

    <hr>

    <section class="dashboard-section category-management">
      <h2>Gestion des Catégories</h2>
      <div class="controls-bar">
        <input
          type="text"
          v-model="searchCategories"
          placeholder="Rechercher par nom ou description"
          class="search-input"
        />
        <select v-model="sortCategoriesBy" class="sort-select">
          <option value="name">Trier par Nom</option>
          <option value="description">Trier par Description</option>
        </select>
        <button @click="openCreateCategoryModal" class="add-button">Ajouter une catégorie</button>
      </div>
      <div v-if="loadingCategories" class="loading-message">Chargement des catégories...</div>
      <div v-else-if="categoryFetchError" class="error-message">{{ categoryFetchError }}</div>
      <div v-else-if="paginatedCategories.length === 0" class="no-data-message">Aucune catégorie trouvée.</div>
      <table v-else class="data-table categories-table">
        <thead>
          <tr>
            <th>Nom</th>
            <th>Description</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="category in paginatedCategories" :key="category.id">
            <td>{{ category.name }}</td>
            <td>{{ category.description }}</td>
            <td class="actions">
              <button class="action-button edit" @click="openEditCategoryModal(category)">Modifier</button>
              <button @click="deleteCategory(category)" class="action-button delete">Supprimer</button>
            </td>
          </tr>
        </tbody>
      </table>
      <div class="pagination">
        <button @click="changePage('categories', 'prev')" :disabled="currentCategoryPage <= 1">Précédent</button>
        <span>Page {{ currentCategoryPage }} sur {{ totalCategoryPages }}</span>
        <button @click="changePage('categories', 'next')" :disabled="currentCategoryPage >= totalCategoryPages">Suivant</button>
      </div>
    </section>

    <div v-if="showEditCategoryModal" class="modal-overlay">
      <div class="modal-content">
        <h3>Modifier la catégorie</h3>
        <form @submit.prevent="updateCategory">
          <div class="form-group">
            <label for="edit-cat-name">Nom :</label>
            <input type="text" id="edit-cat-name" v-model="editedCategory.name" required />
          </div>
          <div class="form-group">
            <label for="edit-cat-description">Description :</label>
            <textarea id="edit-cat-description" v-model="editedCategory.description" required></textarea>
          </div>
          <div class="modal-actions">
            <button type="submit" class="button-primary">Sauvegarder</button>
            <button type="button" @click="closeEditCategoryModal" class="button-secondary">Annuler</button>
          </div>
        </form>
      </div>
    </div>


    <hr>

    <section class="dashboard-section resource-management">
      <h2>Gestion des Ressources</h2>
      <div class="controls-bar">
        <input
          type="text"
          v-model="searchResources"
          placeholder="Rechercher par nom, type ou date"
          class="search-input"
        />
        <select v-model="sortResourcesBy" class="sort-select">
          <option value="name">Trier par Nom</option>
          <option value="type">Trier par Type</option>
          <option value="createdAt">Trier par Date de création</option>
        </select>
        <button @click="openCreateResourceModal" class="add-button">Ajouter une ressource</button>
      </div>
      <div v-if="loadingResources" class="loading-message">Chargement des ressources...</div>
      <div v-else-if="resourceFetchError" class="error-message">{{ resourceFetchError }}</div>
      <div v-else-if="paginatedResources.length === 0" class="no-data-message">Aucune ressource trouvée.</div>
<table v-else class="data-table resources-table">
  <thead>
  <tr>
    <th>Nom</th>
    <th>Type</th>
    <th>Statut</th>       
    <th>Créé le</th>
    <th>Validation requise</th>
    <th>Actions</th>
  </tr>
</thead>

<tbody>
  <tr v-for="resource in paginatedResources" :key="resource.id">
    <td>{{ resource.title }}</td>
    <td>{{ resource.type }}</td>
    <td>
      <span :class="'status-tag status-' + (resource.status || 'PENDING').toLowerCase()">
        {{ resource.status || 'PENDING' }}
      </span>
    </td>
    <td>{{ resource.createdAt }}</td>
    <td>
      <span v-if="resource.needsValidation" class="status-pending">Oui</span>
      <span v-else class="status-active">Non</span>
    </td>
    <td class="actions">
      <button @click="openStatusModal(resource)" class="action-button validate">
        Changer statut
      </button>
      <button class="action-button edit"  @click="openEditResourceModal(resource)">Modifier</button>
      <button class="action-button delete" @click="deleteResource(resource)">Supprimer</button>
    </td>
  </tr>
</tbody>

</table>
      <div class="pagination">
        <button @click="changePage('resources', 'prev')" :disabled="currentResourcePage <= 1">Précédent</button>
        <span>Page {{ currentResourcePage }} sur {{ totalResourcePages }}</span>
        <button @click="changePage('resources', 'next')" :disabled="currentResourcePage >= totalResourcePages">Suivant</button>
      </div>

  <div v-if="showEditResourceModal" class="modal-overlay">
  <div class="modal-content">
    <h3>Modifier la ressource</h3>

    <form @submit.prevent="updateResource">
      <div class="form-group">
        <label for="edit-title">Titre :</label>
        <input id="edit-title" v-model="selectedResource.title" required />
      </div>

      <div class="form-group">
        <label for="edit-content">Contenu :</label>
        <textarea id="edit-content" v-model="selectedResource.content" required></textarea>
      </div>

      <div class="form-group">
        <label for="edit-type">Type :</label>
        <select id="edit-type" v-model="selectedResource.type" required>
          <option value="ARTICLE">ARTICLE</option>
          <option value="VIDEO">VIDEO</option>
          <option value="PICTURE">PICTURE</option>
        </select>
      </div>


      <div
        class="form-group"
        v-if="isAdmin"
      >
        <label for="edit-status">Statut :</label>
        <select id="edit-status" v-model="selectedResource.status" required>
          <option value="PENDING">PENDING</option>
          <option value="ACCEPTED">ACCEPTED</option>
          <option value="REJECTED">REJECTED</option>
          <option value="BLOCKED">BLOCKED</option>
        </select>
      </div>

      <div class="form-group">
        <label for="edit-category">Catégorie :</label>
        <select id="edit-category" v-model="selectedResource.category.id" required>
          <option v-for="cat in categories" :key="cat.id" :value="cat.id">
            {{ cat.name }}
          </option>
        </select>
      </div>

      <div class="modal-actions">
        <button type="submit" class="button-primary">Sauvegarder</button>
        <button type="button" @click="closeEditResourceModal" class="button-secondary">
          Annuler
        </button>
      </div>
    </form>
  </div>
</div>
    </section>

<div v-if="showStatusModal" class="modal-overlay">
  <div class="modal-content">
    <h3>Changer le statut de : {{ selectedResource?.name }}</h3>

    <div class="form-group">
      <label>Nouveau statut :</label>
      <select v-model="statusForm.status">
        <option v-for="s in statusOptions" :key="s" :value="s">
          {{ s }}
        </option>
      </select>
    </div>

    <div class="modal-actions">
      <button class="button-primary" @click="saveStatus">Enregistrer</button>
      <button class="button-secondary" @click="closeStatusModal">Annuler</button>
    </div>
  </div>
</div>



    <div v-if="showCreateUserModal" class="modal-overlay">
      <div class="modal-content">
        <h3>Créer un nouvel utilisateur</h3>
        <form @submit.prevent="createUser">
          <div class="form-group">
            <label for="new-firstname">Prénom :</label>
            <input type="text" id="new-firstname" v-model="newUser.firstName" required />
          </div>
          <div class="form-group">
            <label for="new-lastname">Nom :</label>
            <input type="text" id="new-lastname" v-model="newUser.name" required />
          </div>
          <div class="form-group">
            <label for="new-username">Nom d'utilisateur :</label>
            <input type="text" id="new-username" v-model="newUser.username" required />
          </div>
          <div class="form-group">
            <label for="new-email">Email :</label>
            <input type="email" id="new-email" v-model="newUser.email" required />
          </div>
          <div class="form-group">
            <label for="new-password">Mot de passe :</label>
            <input
              type="password"
              id="new-password"
              v-model="newUser.password"
              placeholder="Ex. Aa1!aaaa"
              required
            />
            <small style="color:#888">
              8+ caractères, avec majuscule, minuscule, chiffre et caractère spécial.
            </small>
          </div>

          <div class="form-group">
            <label for="new-role">Rôle :</label>
            <select id="new-role" v-model="newUser.role" required>
              <option value="USER">USER</option>
              <option value="MODERATOR">MODERATOR</option>
              <option value="ADMIN">ADMIN</option>
            </select>
          </div>
          <div class="modal-actions">
            <button type="submit" class="button-primary">Créer</button>
            <button type="button" @click="closeCreateUserModal" class="button-secondary">Annuler</button>
          </div>
        </form>
      </div>
    </div>

    <div v-if="showEditUserModal" class="modal-overlay">
  <div class="modal-content">
    <h3>Modifier l'utilisateur : {{ selectedUser.username }}</h3>
    <form @submit.prevent="updateUser">
      
      <!-- Nom d'utilisateur -->
      <div class="form-group">
        <label for="edit-username">Nom d'utilisateur :</label>
        <input
          type="text"
          id="edit-username"
          v-model="selectedUser.username"
          required
        />
      </div>

      <!-- Email -->
      <div class="form-group">
        <label for="edit-email">Email :</label>
        <input
          type="email"
          id="edit-email"
          v-model="selectedUser.email"
          required
        />
      </div>

      <!-- Mot de passe -->
      <div class="form-group">
        <label for="edit-password">Nouveau mot de passe (laisser vide pour ne pas modifier) :</label>
        <input
          type="password"
          id="edit-password"
          v-model="selectedUser.password"
          placeholder="Ex. Aa1!aaaa"
        />
        <small style="color: #888">
          8+ caractères, avec majuscule, minuscule, chiffre et caractère spécial.
        </small>
      </div>

      <!-- Rôle -->
      <div class="form-group">
        <label for="edit-role">Rôle :</label>
        <select id="edit-role" v-model="selectedUser.role" required>
          <option value="USER">USER</option>
          <option value="MODERATOR">MODERATOR</option>
          <option value="ADMIN">ADMIN</option>
        </select>
      </div>

      <div class="modal-actions">
        <button type="submit" class="button-primary">Sauvegarder</button>
        <button type="button" @click="closeEditUserModal" class="button-secondary">Annuler</button>
      </div>

    </form>
  </div>
</div>


    <div v-if="showBanModal" class="modal-overlay">
      <div class="modal-content">
        <h3>Bannir l'utilisateur : {{ selectedUser ? selectedUser.username : '' }}</h3>
        <form @submit.prevent="banUser">
          <div class="form-group">
            <label for="ban-duration">Durée du bannissement (secondes) :</label>
            <input type="number" id="ban-duration" v-model.number="banDuration" min="1" required />
          </div>
          <div class="modal-actions">
            <button type="submit" class="button-danger">Bannir</button>
            <button type="button" @click="closeBanModal" class="button-secondary">Annuler</button>
          </div>
        </form>
      </div>
    </div>

    <div v-if="showCreateCategoryModal" class="modal-overlay">
      <div class="modal-content">
        <h3>Créer une nouvelle catégorie</h3>
        <form @submit.prevent="createCategory">
          <div class="form-group">
            <label for="new-cat-name">Nom :</label>
            <input type="text" id="new-cat-name" v-model="newCategory.name" required />
          </div>
          <div class="form-group">
            <label for="new-cat-description">Description :</label>
            <textarea id="new-cat-description" v-model="newCategory.description" required></textarea>
          </div>
          <div class="modal-actions">
            <button type="submit" class="button-primary">Créer</button>
            <button type="button" @click="closeCreateCategoryModal" class="button-secondary">Annuler</button>
          </div>
        </form>
      </div>
    </div>

    <div v-if="showCreateResourceModal" class="modal-overlay">
      <div class="modal-content">
        <h3>Créer une nouvelle ressource</h3>
        <form @submit.prevent="createResource">
          <div class="form-group">
            <label for="res-title">Titre :</label>
            <input type="text" id="res-title" v-model="newResource.title" required />
          </div>
          <div class="form-group">
            <label for="res-content">Contenu :</label>
            <textarea id="res-content" v-model="newResource.content" required></textarea>
          </div>
          <div class="form-group">
            <label for="res-type">Type de ressource :</label>
            <select id="res-type" v-model="newResource.type" required>
              <option disabled value="">Sélectionner un type</option>
              <option value="ARTICLE">Article</option>
              <option value="VIDEO">Vidéo</option>
              <option value="PICTURE">Image</option>
            </select>
          </div>
          <div class="form-group">
            <label for="res-category">Catégorie :</label>
            <select id="res-category" v-model="newResource.category" required>
              <option value="">Sélectionner une catégorie</option>
              <option v-for="cat in categories" :key="cat.id" :value="cat.id">{{ cat.name }}</option>
            </select>
          </div>
          <div class="form-group">
            <label for="res-privacy">Visibilité :</label>
            <select id="res-privacy" v-model="newResource.isPrivate">
              <option value="public">Publique</option>
              <option value="private">Privée</option>
            </select>
          </div>
          <div class="form-group">
            <label for="res-video-link">Lien Vidéo (optionnel) :</label>
            <input type="text" id="res-video-link" v-model="newResource.videoLink" />
          </div>
          <div class="modal-actions">
            <button type="submit" class="button-primary">Créer</button>
            <button type="button" @click="closeCreateResourceModal" class="button-secondary">Annuler</button>
          </div>
        </form>
      </div>
    </div>

  </div>
</template>

<script>
import { defineComponent } from "vue";
import { useAuthStore } from '@/stores/auth';



export default defineComponent({
  components: {
  },
  data() {
    return {
      users: [],
      categories: [],
      resources: [],
      currentUserPage: 1,
      usersPerPage: 5,
      currentCategoryPage: 1,
      categoriesPerPage: 5,
      currentResourcePage: 1,
      resourcesPerPage: 5,
      searchUsers: '',
      sortUsersBy: 'username',
      filterUsersByRole: '',
      filterUsersByStatus: '',
      searchCategories: 'name',
      sortCategoriesBy: 'name',
      searchResources: '',
      sortResourcesBy: 'title',
      showCreateUserModal: false,
      newUser: { username: '', email: '', password: '', role: 'USER', firstName: '', name: '' },
      showEditUserModal: false,
      editedUser: null,
      showCreateCategoryModal: false,
      newCategory: { name: '', description: '' },
      showCreateResourceModal: false,
      showEditResourceModal : false,  
      showStatusModal       : false,  
      selectedResource      : null,   
      statusForm            : { status: 'PENDING' },       
      statusOptions         : ['PENDING', 'ACCEPTED', 'REJECTED', 'BLOCKED'],
      newResource: {
      title: '',
      content: '',
      category: '',
      isPrivate: 'public',
      videoLink: '', 
      type:''
      },
      showBanModal: false,
      selectedUser: null,
      banDuration: null,
      loadingUsers: false,
      loadingCategories: false,
      loadingResources: false,
      showEditCategoryModal: false,
      editedCategory: null,
      userFetchError: null,
      categoryFetchError: null,
      resourceFetchError: null,
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
    const q = this.searchUsers.toLowerCase()
    return this.users.filter(u => {
      const txtOK = `${u.username ?? ''} ${u.email ?? ''}`.toLowerCase().includes(q)

      const roleOK   = !this.filterUsersByRole   || u.role?.name === this.filterUsersByRole
      const statusOK = !this.filterUsersByStatus || (
        (this.filterUsersByStatus === 'Actif'       && u.status === 'ACTIVE')  ||
        (this.filterUsersByStatus === 'Désactivé'   && u.status === 'INACTIVE')||
        (this.filterUsersByStatus === 'Banni'       && u.timeBan  > 0)
      )
      return txtOK && roleOK && statusOK
    })
    },
    filteredAndSortedUsers() {
    const arr = [...this.filteredUsers]
    switch (this.sortUsersBy) {
      case 'username': return arr.sort((a,b)=>a.username.localeCompare(b.username))
      case 'email'   : return arr.sort((a,b)=>a.email   .localeCompare(b.email))
      case 'role'    : return arr.sort((a,b)=>(a.role?.name ?? '')
                                                .localeCompare(b.role?.name ?? ''))
      case 'status'  : return arr.sort((a,b)=>(a.status ?? '').localeCompare(b.status ?? ''))
      default        : return arr
      }
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
    const q = this.searchCategories.toLowerCase()
    return this.categories.filter(c =>
      `${c.name ?? ''} ${c.description ?? ''}`.toLowerCase().includes(q)
    )
    },
    filteredAndSortedCategories() {
      const arr = [...this.filteredCategories]
      return this.sortCategoriesBy === 'description'
        ? arr.sort((a,b)=>a.description.localeCompare(b.description))
        : arr.sort((a,b)=>a.name       .localeCompare(b.name))
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
    const q = this.searchResources.toLowerCase()
    return this.resources.filter(r => {
      const txt = `${r.title ?? r.name ?? ''} ${r.type ?? ''}`.toLowerCase()
      const date = (r.createdAt ?? '').toLowerCase()
      return txt.includes(q) || date.includes(q)
    })
  },
  filteredAndSortedResources() {
    const arr = [...this.filteredResources]
    switch (this.sortResourcesBy) {
      case 'title'    : return arr.sort((a,b)=>(a.title ?? '').localeCompare(b.title ?? ''))
      case 'type'     : return arr.sort((a,b)=>(a.type  ?? '').localeCompare(b.type  ?? ''))
      case 'createdAt': return arr.sort((a,b)=>new Date(a.createdAt) - new Date(b.createdAt))
      default         : return arr
    }
  }, 
}, 
  methods: {    
      getAuthHeaders() {
        const token = localStorage.getItem('jwt_token');
        if (token) {
          return {
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json'
          };
        }
        return { 'Content-Type': 'application/json' };
      },

      openStatusModal(resource) {
        this.selectedResource = resource
        this.statusForm.status = resource.status || 'PENDING'
        this.showStatusModal = true
      },

      async updateCategory() {
        try {
          const res = await fetch(`api/category/${this.editedCategory.id}`, {
            method: 'PATCH',
            headers: this.getAuthHeaders(),
            body: JSON.stringify(this.editedCategory)
          });

          if (!res.ok) {
            const text = await res.text();
            throw new Error(`HTTP ${res.status} - ${text}`);
          }

          const updated = await res.json();
          const index = this.categories.findIndex(c => c.id === updated.id);
          if (index !== -1) this.categories.splice(index, 1, updated);

          alert('Catégorie mise à jour !');
          this.closeEditCategoryModal();
          this.fetchCategories();
        } catch (error) {
          alert("Erreur lors de la mise à jour de la catégorie : " + error.message);
        }
      },


      openEditCategoryModal(category) {
        this.editedCategory = { ...category }
        this.showEditCategoryModal = true
      },

      closeEditCategoryModal() {
        this.showEditCategoryModal = false
        this.editedCategory = null
      },

      async saveStatus() {
      if (!this.selectedResource) return;

      const updatedPayload = {
        title: this.selectedResource.title,
        content: this.selectedResource.content,
        videoLink: this.selectedResource.videoLink,
        visibility: this.selectedResource.visibility || 'PUBLIC',
        status: this.statusForm.status,
        type: this.selectedResource.type,
        categoryId: this.selectedResource.category.id
      };

      try {
        const res = await fetch(`/api/resources/${this.selectedResource.id}`, {
          method: 'PATCH',
          headers: {
            ...this.getAuthHeaders(),
            'Content-Type': 'application/json'
          },
          body: JSON.stringify(updatedPayload)
        });

        if (!res.ok) {
          const errTxt = await res.text();
          throw new Error(`HTTP ${res.status} – ${errTxt}`);
        }

        const updatedResource = await res.json();
        const index = this.resources.findIndex(r => r.id === updatedResource.id);
        if (index !== -1) this.resources.splice(index, 1, updatedResource);

        this.showStatusModal = false;
        alert('Statut mis à jour !');
      } catch (e) {
        console.error('update status error', e);
        alert('Impossible de mettre à jour le statut : ' + e.message);
      }
    },

    closeStatusModal() {
      this.showStatusModal = false
      this.selectedResource = null
    },

    openEditResourceModal(resource) {
      this.selectedResource = { ...resource } // copie pour édition
      this.showEditResourceModal = true
    },

    closeEditResourceModal() {
      this.showEditResourceModal = false
      this.selectedResource = null
    },

    async updateResource() {
      if (!this.selectedResource || !this.selectedResource.id) return
      try {
        const payload = {
          title: this.selectedResource.title,
          content: this.selectedResource.content,
          type: this.selectedResource.type,
          categoryId: this.selectedResource.category.id,
          status: this.selectedResource.status
        }

        const res = await fetch(`api/resources/${this.selectedResource.id}`, {
          method: 'PATCH',
          headers: {
            ...this.getAuthHeaders(),
            'Content-Type': 'application/json'
          },
          body: JSON.stringify(payload)
        })

        if (!res.ok) {
          const errTxt = await res.text()
          throw new Error(`HTTP ${res.status} – ${errTxt}`)
        }

        const updated = await res.json()
        const index = this.resources.findIndex(r => r.id === updated.id)
        if (index !== -1) this.resources.splice(index, 1, updated)

        alert('Ressource mise à jour !')
        this.closeEditResourceModal()
      } catch (e) {
        console.error('update error', e)
        alert('Erreur lors de la mise à jour : ' + e.message)
      }
    },

    closeEditResourceModal() {
    this.selectedResource = null
    this.showEditResourceModal = false
    },

    userStatusClass(user) {
      if (user.banDuration && user.banDuration > 0) return 'status-banned';
      if (user.enabled === false) return 'status-suspended';
      return 'status-active';
    },

    async deleteResource(resource) {
  if (!resource || !resource.id) return;

  if (confirm(`Êtes-vous sûr de vouloir supprimer la ressource « ${resource.title} » ? Cette action est irréversible.`)) {
    try {
      const response = await fetch(`api/resources/${resource.id}`, {
        method: 'DELETE',
        headers: this.getAuthHeaders(), // Authentification requise
      });

      if (!response.ok) {
        const errorText = await response.text();
        throw new Error(`Erreur HTTP ! statut : ${response.status} - ${errorText}`);
      }

      this.resources = this.resources.filter(r => r.id !== resource.id);
      alert('Ressource supprimée avec succès.');
    } catch (error) {
      console.error("Erreur lors de la suppression de la ressource :", error);
      alert('Échec de la suppression de la ressource : ' + error.message);
    }
  }
},

    async fetchUsers() {
      this.loadingUsers = true;
      this.userFetchError = null;
      try {
        const response = await fetch('api/users', {
          headers: this.getAuthHeaders() 
        });
        if (!response.ok) {
          if (response.status === 401 || response.status === 403) {
            throw new Error("Accès non autorisé. Veuillez vous connecter.");
          }
          throw new Error(`Erreur HTTP ! statut : ${response.status}`);
        }
        const data = await response.json();
        this.users = data;
        console.log("Utilisateurs récupérés :", this.users);
      } catch (error) {
        console.error("Erreur lors de la récupération des utilisateurs :", error);
        this.userFetchError = error.message || "Échec du chargement des utilisateurs. Veuillez réessayer.";
      } finally {
        this.loadingUsers = false;
      }
    },

    openCreateUserModal() {
      this.showCreateUserModal = true;
      this.newUser = {
        username: '',
        email: '',
        password: '',
        role: 'USER',
        firstName: '', 
        name: ''        
      };
    },

    closeCreateUserModal() {
      this.showCreateUserModal = false;
    },

    async createUser() {
      const { username, email, password, role, firstName, name } = this.newUser;

      if (!username || !email || !password || !role || !firstName || !name) {
        alert('Tous les champs sont obligatoires (Nom, Prénom, Email, Nom d’utilisateur, Mot de passe, Rôle).');
        return;
      }

      const pwdRule = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^\w\s]).{8,}$/;
      if (!pwdRule.test(password)) {
        alert("Le mot de passe doit contenir :\n• une majuscule\n• une minuscule\n• un chiffre\n• un caractère spécial\n• au moins 8 caractères");
        return;
      }

      try {
        console.log('Payload envoyé :', this.newUser); // debug
        const response = await fetch('api/admin/create', {
          method: 'POST',
          headers: this.getAuthHeaders(),
          body: JSON.stringify(this.newUser),
        });

        if (!response.ok) {
          const errorText = await response.text();
          throw new Error(`Erreur HTTP ! statut : ${response.status} - ${errorText}`);
        }

        const createdUser = await response.json();
        this.users.push(createdUser);
        this.closeCreateUserModal();
        alert('Utilisateur créé avec succès !');
        this.fetchUsers();
      } catch (error) {
        console.error("Erreur lors de la création de l'utilisateur :", error);
        alert('Échec de la création de l\'utilisateur : ' + error.message);
      }
    },


    openEditUserModal(user) {
      this.selectedUser = {
        id: user.id,
        username: user.username,
        email: user.email,
        role: user.role?.name || 'USER',
        password: '' // ← champ vide pour laisser le choix
      };
      this.showEditUserModal = true;
    },
    closeEditUserModal() {
        this.showEditUserModal = false;
        this.selectedUser = null;
    },
    async updateUser() {
      if (!this.selectedUser || !this.selectedUser.id) return;

      const rule = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^\w\s]).{8,}$/;
      console.log('Password saisi :', this.selectedUser.password);
      console.log('Passe la règle ? →', rule.test(this.selectedUser.password));

      const updatePayload = {
        username: this.selectedUser.username,
        email: this.selectedUser.email,
        role: { name: this.selectedUser.role }
      };

      // Vérification du mot de passe s’il est rempli
      if (this.selectedUser.password && this.selectedUser.password.trim() !== '') {
        const passwordRule = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^\w\s]).{8,}$/;
        if (!passwordRule.test(this.selectedUser.password)) {
          alert("Le mot de passe doit contenir au moins :\n• une majuscule\n• une minuscule\n• un chiffre\n• un caractère spécial\n• et faire 8 caractères minimum.");
          return;
        }
        updatePayload.password = this.selectedUser.password;
      }

      try {
        const response = await fetch(`api/users/${this.selectedUser.id}`, {
          method: 'PATCH',
          headers: this.getAuthHeaders(),
          body: JSON.stringify(updatePayload),
        });

        if (!response.ok) {
          const errorText = await response.text();
          throw new Error(`Erreur HTTP ! statut : ${response.status} - ${errorText}`);
        }

        const updatedUser = await response.json();
        const index = this.users.findIndex(u => u.id === updatedUser.id);
        if (index !== -1) {
          this.users.splice(index, 1, updatedUser);
        }

        this.closeEditUserModal();
        alert('Utilisateur mis à jour avec succès !');
        this.fetchUsers();
      } catch (error) {
        console.error("Erreur lors de la mise à jour de l'utilisateur :", error);
        alert('Échec de la mise à jour de l\'utilisateur : ' + error.message);
      }
    },


    async toggleUserStatus(user) {
      if (!user || !user.id) return;

      const isActive = user.status === 'ACTIVE';
      const newStatusText = isActive ? 'désactiver' : 'activer';

      if (confirm(`Êtes-vous sûr de vouloir ${newStatusText} l'utilisateur ${user.username} ?`)) {
        try {
          const response = await fetch(`/api/users/${user.id}/toggle-status`, {
            method: 'PATCH',
            headers: this.getAuthHeaders()
          });

          if (!response.ok) {
            const errorText = await response.text();
            throw new Error(`Erreur HTTP ${response.status} - ${errorText}`);
          }

          const updatedUser = await response.json();
          const index = this.users.findIndex(u => u.id === updatedUser.id);
          if (index !== -1) {
            this.users.splice(index, 1, updatedUser);
          }

          alert(`Utilisateur ${user.username} ${newStatusText} avec succès.`);
        } catch (error) {
          console.error(`Erreur lors de la mise à jour du statut :`, error);
          alert(`Échec de la mise à jour du statut : ` + error.message);
        }
      }
    },


    async deleteUser(user) {
      if (!user || !user.id) return;
      if (confirm(`Êtes-vous sûr de vouloir supprimer l'utilisateur ${user.username} ? Cette action est irréversible.`)) {
        try {
          const response = await fetch(`api/users/${user.id}`, {
            method: 'DELETE',
            headers: this.getAuthHeaders(), // Cette opération nécessite toujours l'authentification
          });
          if (!response.ok) {
            const errorText = await response.text();
            throw new Error(`Erreur HTTP ! statut : ${response.status} - ${errorText}`);
          }
          this.users = this.users.filter(u => u.id !== user.id);
          alert('Utilisateur supprimé avec succès.');
        } catch (error) {
          console.error("Erreur lors de la suppression de l'utilisateur :", error);
          alert('Échec de la suppression de l\'utilisateur : ' + error.message);
        }
      }
    },

    async fetchCategories() {
        this.loadingCategories = true;
        this.categoryFetchError = null;
        try {
            const response = await fetch('api/category', { headers: this.getAuthHeaders() }); // Garde l'authentification
            if (!response.ok) {
                if (response.status === 401 || response.status === 403) throw new Error("Accès non autorisé.");
                throw new Error(`Erreur HTTP ! statut : ${response.status}`);
            }
            this.categories = await response.json();
        } catch (error) {
            console.error("Erreur lors de la récupération des catégories :", error);
            this.categoryFetchError = error.message || "Échec du chargement des catégories.";
        } finally {
            this.loadingCategories = false;
        }
    },
    openCreateCategoryModal() { this.showCreateCategoryModal = true; this.newCategory = { name: '', description: '' }; },
    closeCreateCategoryModal() { this.showCreateCategoryModal = false; },
    async createCategory() {
        if (this.newCategory.name && this.newCategory.description) {
            try {
                const response = await fetch('api/category', {
                    method: 'POST',
                    headers: this.getAuthHeaders(), // Garde l'authentification
                    body: JSON.stringify(this.newCategory),
                });
                if (!response.ok) {
                    const errorText = await response.text();
                    throw new Error(`Erreur HTTP ! statut : ${response.status} - ${errorText}`);
                }
                const createdCategory = await response.json();
                this.categories.push(createdCategory);
                this.closeCreateCategoryModal();
                alert('Catégorie créée avec succès !');
                this.fetchCategories();
            } catch (error) {
                console.error("Erreur lors de la création de la catégorie :", error);
                alert('Échec de la création de la catégorie : ' + error.message);
            }
        } else {
            alert('Veuillez remplir tous les champs pour créer une catégorie.');
        }
    },
    async deleteCategory(category) {
        if (!category || !category.id) return;
        if (confirm(`Êtes-vous sûr de vouloir supprimer la catégorie ${category.name} ?`)) {
            try {
                const response = await fetch(`api/category/${category.id}`, {
                    method: 'DELETE',
                    headers: this.getAuthHeaders(), 
                });
                if (!response.ok) {
                    const errorText = await response.text();
                    throw new Error(`Erreur HTTP ! statut : ${response.status} - ${errorText}`);
                }
                this.categories = this.categories.filter(c => c.id !== category.id);
                alert('Catégorie supprimée avec succès.');
            } catch (error) {
                console.error("Erreur lors de la suppression de la catégorie :", error);
                alert('Échec de la suppression de la catégorie : ' + error.message);
            }
        }
    },

    async fetchResources() {
        this.loadingResources = true;
        this.resourceFetchError = null;
        try {
            const response = await fetch('api/resources', { headers: this.getAuthHeaders() }); // Garde l'authentification
            if (!response.ok) {
                if (response.status === 401 || response.status === 403) throw new Error("Accès non autorisé.");
                throw new Error(`Erreur HTTP ! statut : ${response.status}`);
            }
            this.resources = await response.json();
        } catch (error) {
            console.error("Erreur lors de la récupération des ressources :", error);
            this.resourceFetchError = error.message || "Échec du chargement des ressources.";
        } finally {
            this.loadingResources = false;
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
    closeCreateResourceModal() { this.showCreateResourceModal = false; },
    async createResource() {
  if (this.newResource.title && this.newResource.content && this.newResource.category) {
    const payload = {
      title: this.newResource.title,
      content: this.newResource.content,
      categoryId: this.newResource.category,
      videoLink: this.newResource.videoLink || null,
      type: this.newResource.type, 
      visibility: this.newResource.isPrivate === 'private' ? 'PRIVATE' : 'PUBLIC'
    };

    try {
      const response = await fetch('api/resources', {
        method: 'POST',
        headers: this.getAuthHeaders(),
        body: JSON.stringify(payload),
      });

      if (!response.ok) {
        const errorText = await response.text();
        throw new Error(`Erreur HTTP ! statut : ${response.status} - ${errorText}`);
      }

      const createdResource = await response.json();
      this.resources.push(createdResource);
      this.closeCreateResourceModal();
      alert('Ressource créée avec succès !');
      this.fetchResources();
    } catch (error) {
      console.error("Erreur lors de la création de la ressource :", error);
      alert('Échec de la création de la ressource : ' + error.message);
    }
  } else {
    alert('Veuillez remplir les champs obligatoires (Titre, Contenu, Catégorie).');
  }
    },
    validateResource(resource) {
      alert(`La ressource "${resource.name}" serait validée. Vous devrez implémenter un appel API pour cela.`);
      resource.needsValidation = false;
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
    },

    formatBanDuration(durationInSeconds) {
      if (durationInSeconds <= 0) return '';
      const days = Math.floor(durationInSeconds / (3600 * 24));
      const hours = Math.floor((durationInSeconds % (3600 * 24)) / 3600);
      const minutes = Math.floor((durationInSeconds % 3600) / 60);
      const seconds = durationInSeconds % 60;

      let result = [];
      if (days > 0) result.push(`${days}j`);
      if (hours > 0) result.push(`${hours}h`);
      if (minutes > 0) result.push(`${minutes}m`);
      if (seconds > 0) result.push(`${seconds}s`);

      return result.join(' ');
    },
  },

  mounted() {
    this.fetchUsers();
    this.fetchCategories();
    this.fetchResources();
  }
})

</script>

<style scoped>
@import url('https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css');

.admin-dashboard {
  display: flex;
  flex-direction: column;
  padding: 20px;
  background-color: #f9fafb;
  color: #333;
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

h1 {
  font-size: 2rem;
  margin-bottom: 10px;
}

h2 {
  font-size: 1.5rem;
  margin: 20px 0 10px;
}

.dashboard-section {
  margin-bottom: 40px;
  background-color: #fff;
  border-radius: 10px;
  padding: 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.controls-bar {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  margin-bottom: 16px;
  align-items: center;
}

.search-input,
.filter-select,
.sort-select,
.add-button {
  padding: 8px 12px;
  border: 1px solid #ddd;
  border-radius: 5px;
  font-size: 0.95rem;
}

.add-button {
  background-color: #38bdf8;
  color: #fff;
  border: none;
  cursor: pointer;
  transition: background-color 0.3s;
}

.add-button:hover {
  background-color: #0ea5e9;
}

.data-table {
  width: 100%;
  border-collapse: collapse;
  margin-top: 10px;
}

.data-table th,
.data-table td {
  padding: 12px;
  border-bottom: 1px solid #eee;
  text-align: left;
}

.data-table th {
  background-color: #f3f4f6;
}

.actions {
  display: flex;
  gap: 6px;
}

.action-button {
  padding: 5px 10px;
  font-size: 0.85rem;
  border-radius: 4px;
  border: none;
  cursor: pointer;
}

.action-button.edit {
  background-color: #facc15;
  color: #000;
}

.action-button.delete {
  background-color: #ef4444;
  color: #fff;
}

.action-button.validate {
  background-color: #10b981;
  color: white;
}

.action-button.activate {
  background-color: #22c55e;
  color: white;
}

.action-button.deactivate {
  background-color: #f97316;
  color: white;
}

.status-active {
  color: #16a34a;
  font-weight: 600;
}

.status-suspended {
  color: #f59e0b;
  font-weight: 600;
}

.status-banned {
  color: #dc2626;
  font-weight: 600;
}

.pagination {
  margin-top: 20px;
  display: flex;
  justify-content: center;
  gap: 10px;
  align-items: center;
}

.pagination button {
  background-color: #3b82f6;
  color: white;
  padding: 6px 12px;
  border-radius: 4px;
  border: none;
  cursor: pointer;
}

.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  height: 100vh;
  width: 100vw;
  background-color: rgba(0, 0, 0, 0.4);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.modal-content {
  background-color: #fff;
  border-radius: 10px;
  padding: 24px;
  width: 90%;
  max-width: 500px;
  box-shadow: 0 2px 20px rgba(0, 0, 0, 0.2);
}

.form-group {
  margin-bottom: 15px;
}

.form-group label {
  display: block;
  font-weight: 600;
  margin-bottom: 5px;
}

.form-group input,
.form-group textarea,
.form-group select {
  width: 100%;
  padding: 8px;
  border: 1px solid #d1d5db;
  border-radius: 4px;
  font-size: 0.95rem;
}

.modal-actions {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
  gap: 10px;
}

.button-primary {
  background-color: #3b82f6;
  color: white;
  padding: 8px 16px;
  border-radius: 5px;
  border: none;
  cursor: pointer;
}

.button-secondary {
  background-color: #e5e7eb;
  padding: 8px 16px;
  border-radius: 5px;
  border: none;
  cursor: pointer;
}

.button-danger {
  background-color: #ef4444;
  color: white;
  padding: 8px 16px;
  border-radius: 5px;
  border: none;
  cursor: pointer;
}

.image-preview {
  max-width: 100%;
  height: auto;
  margin-top: 10px;
  border-radius: 6px;
}

.loading-message,
.error-message,
.no-data-message {
  font-style: italic;
  color: #6b7280;
  text-align: center;
  margin-top: 20px;
}
</style>
