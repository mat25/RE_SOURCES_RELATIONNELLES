<template>
  <div class="form-page">
    <n-card class="form-card" title="Connexion" size="huge">
      <n-form :model="credentials" :label-width="120">
        <n-form-item
          label="Nom d'utilisateur"
          :validation-status="usernameError ? 'error' : undefined"
          :feedback="usernameError"
        >
          <n-input
            v-model:value="credentials.username"
            placeholder="Entrez votre nom d'utilisateur"
            @focus="clearError('username')"
          />
        </n-form-item>

        <n-form-item
          label="Mot de passe"
          :validation-status="passwordError ? 'error' : undefined"
          :feedback="passwordError"
        >
          <n-input
            type="password"
            v-model:value="credentials.password"
            placeholder="Entrez votre mot de passe"
            @focus="clearError('password')"
          />
        </n-form-item>

        <n-form-item>
          <n-button type="primary" block :loading="loading" @click="handleSubmit">
            Connexion
          </n-button>
        </n-form-item>
      </n-form>
    </n-card>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { useMessage } from 'naive-ui'
import axios from 'axios'
import { useAuthStore } from '@/stores/auth'

// Init
const router = useRouter()
const message = useMessage()
const auth = useAuthStore()

// Formulaire
const loading = ref(false)
const credentials = reactive({
  username: '',
  password: ''
})

const usernameError = ref('')
const passwordError = ref('')

function clearError(field) {
  if (field === 'username') usernameError.value = ''
  if (field === 'password') passwordError.value = ''
}

function validateForm() {
  let valid = true

  if (!credentials.username.trim()) {
    usernameError.value = "Le nom d'utilisateur est requis."
    valid = false
  }

  if (!credentials.password.trim()) {
    passwordError.value = 'Le mot de passe est requis.'
    valid = false
  }

  return valid
}

async function handleSubmit() {
  if (!validateForm()) {
    message.error('Veuillez corriger les erreurs dans le formulaire.')
    return
  }

  loading.value = true

  try {
    const res = await axios.post('/api/login', {
      username: credentials.username,
      password: credentials.password
    })

    auth.setToken(res.data.token)
    await auth.fetchUser()

    message.success('Connexion réussie !')
    router.push('/')
  } catch (err) {
    if (err.response?.status === 401) {
      message.error('Nom d’utilisateur ou mot de passe incorrect.')
      passwordError.value = 'Identifiants invalides.'
    } else {
      message.error('Erreur serveur.')
    }
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.form-page {
  display: flex;
  justify-content: center;
  min-height: 100vh;
  align-items: center;
  background: #f4f7fb;
  padding: 20px;
}

.form-card {
  width: 400px;
  padding: 40px;
  border-radius: 10px;
  box-shadow: 0 10px 25px rgba(0,0,0,0.1);
  background: white;
}
</style>
