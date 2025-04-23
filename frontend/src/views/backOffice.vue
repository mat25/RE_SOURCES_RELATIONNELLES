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
                label-placement="top"
                @submit.prevent="submitResourceForm"
            >
              <n-form-item label="Titre" path="title">
                <n-input v-model:value="resourceForm.title" placeholder="Titre de la ressource" />
              </n-form-item>
              <n-form-item label="Description" path="description">
                <n-input v-model:value="resourceForm.description" placeholder="Description" />
              </n-form-item>
              <n-form-item label="Lien Vidéo" path="videoLink">
                <n-input v-model:value="resourceForm.videoLink" placeholder="Lien vidéo (facultatif)" />
              </n-form-item>
              <n-button type="primary" native-type="submit">Enregistrer</n-button>
              <n-button @click="cancelResourceForm" style="margin-left: 10px">Annuler</n-button>
            </n-form>

            <n-button @click="showAddResourceForm" style="margin-top: 20px">Ajouter une Ressource</n-button>
          </n-tab-pane>

          <!-- Onglet Catégories -->
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

          <!-- Onglet Utilisateurs -->
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
            <n-button @click="showAddHelperForm">Ajouter un modérateur</n-button>
            <n-button @click="showAddSuperAdminForm">Ajouter un super Admin</n-button>
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
  NSpace,
  NPopconfirm,
  NPagination
} from 'naive-ui';
import { h } from 'vue';

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
    NSpace,
    NPopconfirm,
    NPagination
  },
  data() {
    return {
      resourceColumns: [
        { title: 'Titre', key: 'title' },
        { title: 'Description', key: 'description' },
        {
          title: 'Lien Vidéo',
          key: 'videoLink',
          render(row) {
            return row.videoLink
                ? h('a', { href: row.videoLink, target: '_blank' }, 'Voir la vidéo')
                : 'Aucun lien';
          }
        },
        {
          title: 'Actions',
          key: 'actions',
          render: (row) => {
            return h(NSpace, {}, {
              default: () => [
                h(NButton, { size: 'small', onClick: () => this.editResource(row) }, 'Modifier'),
                h(NPopconfirm, {
                  onPositiveClick: () => this.deleteResource(row.id),
                  positiveText: 'Oui',
                  negativeText: 'Non'
                }, {
                  trigger: () => h(NButton, { size: 'small', type: 'error' }, 'Supprimer'),
                  default: () => 'Supprimer cette ressource ?'
                })
              ]
            });
          }
        }
      ],
      resourceData: [
        {
          id: 1,
          title: 'Introduction à Vue.js',
          description: 'Une ressource pour apprendre les bases de Vue 3.',
          videoLink: 'https://www.youtube.com/watch?v=ZqgiuPt5QZo'
        }
      ],
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
      showUserForm: false,
      userForm: {},
      showAdminForm: false,
      adminForm: {}
    };
  },
  methods: {
    showAddResourceForm() {
      this.resourceForm = {};
      this.showResourceForm = true;
    },
    editResource(resource) {
      this.resourceForm = { ...resource };
      this.showResourceForm = true;
    },
    cancelResourceForm() {
      this.showResourceForm = false;
    },
    submitResourceForm() {
      if (this.resourceForm.id) {
        // modification
        const index = this.resourceData.findIndex(r => r.id === this.resourceForm.id);
        if (index !== -1) {
          this.resourceData.splice(index, 1, { ...this.resourceForm });
        }
      } else {
        // ajout
        const newId = this.resourceData.length
            ? Math.max(...this.resourceData.map(r => r.id)) + 1
            : 1;
        this.resourceData.push({ ...this.resourceForm, id: newId });
      }
      this.showResourceForm = false;
    },
    deleteResource(id) {
      this.resourceData = this.resourceData.filter(r => r.id !== id);
    },
    handlePageChangeResources(page) {
      this.currentPageResources = page;
    },
    showAddCategoryForm() {},
    submitCategoryForm() {},
    showAddUserForm() {},
    showAddAdminForm() {},
    showAddHelperForm() {},
    showAddSuperAdminForm() {},
    submitUserForm() {},
    submitAdminForm() {}
  }
};
</script>

<style scoped>
h1 {
  margin-bottom: 20px;
}
</style>
