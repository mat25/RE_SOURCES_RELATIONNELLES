import { createRouter, createWebHistory } from 'vue-router'
import accueil from "@/views/accueil.vue";
import profil from "@/views/profil.vue";
import inscription from "@/views/inscription.vue";
import connexion from "@/views/connexion.vue";
import resources from "@/views/resources.vue";
import progression from "@/views/progression.vue";
import backOffice from "@/views/backOffice.vue";
import detailResources from "@/views/detailResources.vue";


const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path : '/profil',
      name: 'profil',
      component: profil,
    },

    {
      path: '/inscription',
      name: 'inscription',
      component: inscription,
    },

    {
      path: '/connexion',
      name: 'connexion',
      component: connexion,
    },

    {
      path: '/resources',
      name: 'resources',
      component: resources,
    },

    {
      path: '/progression',
      name: 'progression',
      component: progression,
    },

    {
      path: '/backOffice',
      name: 'Bo',
      component: backOffice,
    },


    {
      path: '/detailRessource',
      name: 'detailRessource',
      component: detailResources
    },


    {
      path: '/',
      name: 'accueil',
      component: accueil,
    }


  ],
})

export default router
