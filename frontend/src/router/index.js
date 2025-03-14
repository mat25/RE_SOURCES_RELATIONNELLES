import { createRouter, createWebHistory } from 'vue-router'
import profil from "@/views/profil.vue";

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path : '/',
      name: 'profil',
      component: profil,
    }
  ],
})

export default router
