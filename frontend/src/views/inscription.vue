<template>
  <div class="form-page">
    <n-card class="form-card" title="Créer un compte" size="huge" header-style="display: none;">
      <n-form
        ref="formRef"
        :model="credentials"
        :rules="rules"
        label-placement="top"
        @submit.prevent="submitInscription"
      >
        <n-space vertical size="large">
          <!-- First and Last name -->
          <n-form-item label="Prénom" path="firstName">
            <n-input v-model:value="credentials.firstName" placeholder="Jean" class="input-field" />
          </n-form-item>
          <n-form-item label="Nom" path="lastName">
            <n-input v-model:value="credentials.lastName" placeholder="Dupont" class="input-field" />
          </n-form-item>

          <!-- Username -->
          <n-form-item label="Pseudo" path="username">
            <n-input v-model:value="credentials.username" placeholder="jean_du_25" class="input-field" />
          </n-form-item>

          <!-- Email -->
          <n-form-item label="Email" path="email">
            <n-input v-model:value="credentials.email" placeholder="exemple@email.com" class="input-field" />
          </n-form-item>

          <!-- Password -->
          <n-form-item label="Mot de passe" path="password">
            <n-input
              v-model:value="credentials.password"
              type="password"
              show-password-on="click"
              placeholder="Mot de passe"
              class="input-field"
            />
          </n-form-item>

          <!-- Confirm Password -->
          <n-form-item label="Confirmer le mot de passe" path="confirmPassword">
            <n-input
              v-model:value="credentials.confirmPassword"
              type="password"
              show-password-on="click"
              placeholder="Confirmation"
              class="input-field"
            />
          </n-form-item>

          <!-- Submit Button -->
          <n-button
            type="primary"
            block
            strong
            round
            size="large"
            @click="submitInscription"
            class="submit-button"
          >
            Créer un compte
          </n-button>

          <!-- Link to login if already have an account -->
          <p class="login-link">
            Vous avez déjà un compte ? <a href="/login">Connectez-vous ici</a>.
          </p>
        </n-space>
      </n-form>
    </n-card>
  </div>
</template>

<script setup>
import { reactive, ref } from 'vue'
import { useMessage } from 'naive-ui'
import axios from 'axios'

const formRef = ref(null)
const message = useMessage()

const credentials = reactive({
  firstName: '',
  lastName: '',
  username: '',
  email: '',
  password: '',
  confirmPassword: '',
})

const rules = {
  firstName: [{ required: true, message: 'Prénom requis', trigger: 'blur' }],
  lastName: [{ required: true, message: 'Nom requis', trigger: 'blur' }],
  username: [{ required: true, message: 'Pseudo requis', trigger: 'blur' }],
  email: [
    { required: true, message: 'Email requis', trigger: 'blur' },
    { type: 'email', message: 'Email invalide', trigger: ['blur', 'input'] },
  ],
  password: [
    { required: true, message: 'Mot de passe requis', trigger: 'blur' },
    { min: 6, message: '6 caractères minimum', trigger: 'blur' },
  ],
  confirmPassword: [
    {
      validator: (_, value) =>
        value === credentials.password
          ? true
          : new Error('Les mots de passe ne correspondent pas'),
      trigger: ['blur', 'input'],
    },
  ],
}

const submitInscription = async () => {
  formRef.value?.validate(async (errors) => {
    if (!errors) {
      try {
        const response = await axios.post('/api/register', {
          firstName: credentials.firstName,
          name: credentials.lastName,
          username: credentials.username,
          email: credentials.email,
          password: credentials.password,
        })

        const token = response.data.token
        localStorage.setItem('token', token)

        message.success('Inscription réussie 🎉')
        this.$router.push('/');
      } catch (err) {
        console.error(err)
        message.error('Erreur lors de l’inscription')
      }
    } else {
      message.error('Veuillez corriger les erreurs')
    }
  })
}
</script>

<style scoped>
.form-page {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;  /* On garde 100vh ici, mais on permet au formulaire de s'ajuster */
  background: #e9eff1;
  padding: 20px;
}

.form-card {
  width: 420px;
  max-width: 100%;
  padding: 40px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
  background-color: white;
  border-radius: 12px;
  border: 1px solid #ddd;
  margin: 0 auto;
  /* Limite la hauteur du formulaire pour éviter qu'il soit trop grand */
  max-height: 90vh;
  overflow-y: auto;
}

.input-field {
  border-radius: 8px;
  padding: 12px 16px;
  font-size: 16px;
  transition: border-color 0.3s ease;
  border: 1px solid #ccc; /* Bordure douce */
  margin-bottom: 20px;
}

.input-field:focus {
  border-color: #007bff; /* Changement de couleur au focus */
}

.submit-button {
  background-color: #007bff;
  border-radius: 8px;
  padding: 14px;
  font-size: 18px;
  transition: all 0.3s;
  margin-top: 20px; /* Espace entre les champs et le bouton */
}

.submit-button:hover {
  background-color: #0056b3; /* Bleu foncé au survol */
  transform: scale(1.05);
}

.submit-button:active {
  transform: scale(0.98);
}

.login-link {
  text-align: center;
  margin-top: 10px;
  font-size: 12px; /* Taille réduite */
}

.login-link a {
  color: #007bff;
  text-decoration: none;
}

.login-link a:hover {
  text-decoration: underline;
}

@media (max-width: 768px) {
  .form-card {
    width: 90%;
    padding: 20px;
  }
}
</style>
