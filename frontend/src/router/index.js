import { createRouter, createWebHistory } from 'vue-router'
import accueil          from '@/views/accueil.vue'
import profil           from '@/views/profil.vue'
import inscription      from '@/views/inscription.vue'
import connexion        from '@/views/connexion.vue'
import resources        from '@/views/resources.vue'
import progression      from '@/views/progression.vue'
import backOffice       from '@/views/backOffice.vue'
import detailResources  from '@/views/detailResources.vue'
import AllResources     from '@/views/allResources.vue'
import { useAuthStore } from '@/stores/auth'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    { path: '/',            name: 'accueil',      component: accueil },
    { path: '/profil',      name: 'profil',       component: profil,      meta: { requiresAuth: true } },
    { path: '/inscription', name: 'inscription',  component: inscription },
    { path: '/connexion',   name: 'connexion',    component: connexion },
    { path: '/resources',   name: 'resources',    component: resources },
    { path: '/progression', name: 'progression',  component: progression },
    {                         
      path: '/backOffice',
      name: 'Bo',
      component: backOffice,
      meta: { requiresRole: ['ADMIN', 'MODERATEUR', 'SUPER_ADMIN'] }
    },
    {
      path: '/resources/:id',
      name: 'detailRessource',
      component: detailResources,
      meta: { requiresAuth: true }
    },
    { path: '/allResource', name: 'allResource', component: AllResources }
  ]
})

/* ---------- Garde de navigation globale ---------- */
router.beforeEach((to, _from, next) => {
  const auth = useAuthStore()

  if (to.meta.requiresAuth && !auth.isAuthenticated) {
    console.warn('🔒 Accès refusé : utilisateur non authentifié')
    return next('/')         // redirection vers l’accueil
  }

  if (to.meta.requiresRole) {
    if (!auth.isAuthenticated) {
      console.warn('🔒 Accès refusé : non authentifié')
      return next('/')
    }

    const role =
      auth.userRole?.name?.toUpperCase?.() ??
      auth.userRole?.toUpperCase?.() ??
      ''

    if (!to.meta.requiresRole.includes(role)) {
      console.warn(`🔒 Accès refusé : rôle ${role} non autorisé`)
      return next('/')
    }
  }

  next()
})

export default router
