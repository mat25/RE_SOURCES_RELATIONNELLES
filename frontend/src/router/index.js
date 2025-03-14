import { createRouter, createWebHistory } from 'vue-router'
import accueil from "@/views/accueil.vue";
import profil from "@/views/profil.vue";


const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path : '/profil',
      name: 'profil',
      component: profil,
    },

    {
      path : '/',
      name: 'accueil',
      component: accueil,
    }
  ],
})

export default router
