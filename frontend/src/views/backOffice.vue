<template>
    <n-layout>
      <n-layout-content>
        <n-card>
          <h1>Back-Office</h1>
  
          <n-tabs type="line">
            <n-tab-pane name="resources" tab="Ressources">
              <n-table :columns="resourceColumns" :data="resourceData" />
              <n-pagination
                :page="currentPageResources"
                :page-count="pageCountResources"
                @update:page="handlePageChangeResources"
              />
              <n-form
                v-if="showResourceForm"
                :model="resourceForm"
                @submit.prevent="submitResourceForm"
              >
                </n-form>
              <n-button @click="showAddResourceForm">Ajouter une Ressource</n-button>
            </n-tab-pane>
  
            <n-tab-pane name="categories" tab="Catégories">
              <n-table :columns="categoryColumns" :data="categoryData" />
              <n-form
                v-if="showCategoryForm"
                :model="categoryForm"
                @submit.prevent="submitCategoryForm"
              >
                </n-form>
              <n-button @click="showAddCategoryForm">Ajouter une Catégorie</n-button>
            </n-tab-pane>
  
            <n-tab-pane name="users" tab="Utilisateurs">
              <n-table :columns="userColumns" :data="userData" />
              <n-form v-if="showUserForm" :model="userForm" @submit.prevent="submitUserForm">
                </n-form>
              <n-form
                v-if="showAdminForm"
                :model="adminForm"
                @submit.prevent="submitAdminForm"
              >
                </n-form>
              <n-button @click="createUser">Ajouter un Utilisateur</n-button>
              <n-button @click="createHelper">Ajouter un Moderateur</n-button>
              <n-button @click="createAdmin">Ajouter un Admin</n-button>
              <n-button @click="createSuperAdmin">Ajouter un SuperAdmin</n-button>
            </n-tab-pane>
          </n-tabs>
        </n-card>
      </n-layout-content>
    </n-layout>
  </template>
  
  <script>
  import {
    NLayout,
    NLayoutContent,
    NCard,
    NTabs,
    NTabPane,
    NTable,
    NButton,
    NForm,
    NFormItem,
    NInput,
    NSelect,
    NRadioGroup,
    NRadio,
    NDatePicker,
    NTag,
    NSpace,
    NIcon,
    NPopconfirm,
    NPagination,
    create,
  } from 'naive-ui';  
  export default {
    components: {
      NLayout,
      NLayoutContent,
      NCard,
      NTabs,
      NTabPane,
      NTable,
      NButton,
      NForm,
      NFormItem,
      NInput,
      NSelect,
      NRadioGroup,
      NRadio,
      NDatePicker,
      NTag,
      NSpace,
      NIcon,
      NPopconfirm,
      NPagination,
    },
    data() {
      return {
        // Données et méthodes pour Ressources (comme dans le code précédent)
        resourceColumns: [],
        resourceData: [],
        categoryOptions: [],
        showResourceForm: false,
        resourceForm: {},
        currentPageResources: 1,
        pageCountResources: 10,
  
        // Données et méthodes pour Catégories (comme dans le code précédent)
        categoryColumns: [],
        categoryData: [],
        showCategoryForm: false,
        categoryForm: {},
  
        // Données et méthodes pour Utilisateurs (comme dans le code précédent)
        userColumns: [],
        userData: [],
        roleOptions: [],
        showUserForm: false,
        userForm: {},
        showAdminForm: false,
        adminForm: {},
      };
    },
    methods: {
      filterRessources() {},
      addResource() {},
      editResource() {},
      banResources() {},
      deleteResource() {},
      validResources() {},

      editCategory() {},
      deleteCategory() {},
  
      banUser() {},
      deleteUser() {},
      validateResource() {},
        
  
      createUser() {},
      createAdmin() {},
      createSuperAdmin() {},
      createHelper() {},

      showStatistiqueOfResource() {},
      filterStatistiqueOfResource() {},


    },
  };
  </script>

// Partie ressources :

    // filtrer les ressources en BO
    // ajouter ou editer une ressources existante
    // supprimer ou suspendre une ressources
    // supprimer une categorie de ressources 


    
// Partie Users :

    // Valider ou non les ressources en attentes 
    // suspendre le compte d'un utilisateur
    // bannir le compte d'un utilisateur


// Partie admin :

    // creer un compte modo, admin, super admin


// statistique :

    // afficher les statistique d'une ressources : nb exploitation, nb consultation, nb favoris, qui la creer
    // permettre les filtre sur : periodes, categorie ...
