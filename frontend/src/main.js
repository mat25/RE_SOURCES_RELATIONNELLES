import './assets/main.css'

import { createApp } from 'vue'
import { createPinia } from 'pinia'
import naive from "naive-ui"

import App from './App.vue'
import router from './router'
import { useAuthStore } from '@/stores/auth'

const app = createApp(App)
const pinia = createPinia()
app.use(pinia)

const auth = useAuthStore(pinia)

// 🔐 Initialise le token dès le départ (si présent dans localStorage)
const storedToken = localStorage.getItem('jwt_token')
if (storedToken) {
  auth.setToken(storedToken)
  auth.fetchUser()
}

app.use(router)
app.use(naive)
app.mount('#app')
