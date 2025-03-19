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
              <n-button @click="showAddUserForm">Ajouter un Utilisateur</n-button>
              <n-button @click="showAddAdminForm">Ajouter un Admin</n-button>
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
        resourceColumns: [],
        resourceData: [],
        categoryOptions: [],
        showResourceForm: false,
        resourceForm: {},
        currentPageResources: 1,
        pageCountResources: 10,
  
        categoryColumns: [],
        categoryData: [],
        showCategoryForm: false,
        categoryForm: {},
  
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
      showAddResourceForm() {},
      editResource() {},
      cancelResourceForm() {},
      submitResourceForm() {},
      deleteResource() {},
      toggleResourceStatus() {},
      handleImageUpload() {},
      handlePageChangeResources() {},
  
      showAddCategoryForm() {},
      editCategory() {},
      cancelCategoryForm() {},
      submitCategoryForm() {},
      deleteCategory() {},
  
      showAddUserForm() {},
      editUser() {},
      cancelUserForm() {},
      submitUserForm() {},
      deleteUser() {},
      toggleUserStatus() {},
  
      showAddAdminForm() {},
      cancelAdminForm() {},
      submitAdminForm() {},
    },
  };
  </script>