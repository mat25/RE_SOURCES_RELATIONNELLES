<template>
  <div class="form-page">
    <n-card class="form-card" title="Connexion" size="huge">
      <n-form @submit.prevent="login" :label-width="100">
        <n-space vertical size="large">
          <div class="form-control">
            <n-form-item label="Email" :error="errors.email">
              <n-input v-model="credentials.email" @input="validateEmail" placeholder="Entrez votre email" class="input-field" />
            </n-form-item>
            <div v-if="errors.email" class="error-message">{{ errors.email }}</div>
          </div>

          <div class="form-control">
            <n-form-item label="Mot de passe" :error="errors.password">
              <n-input type="password" v-model="credentials.password" @input="validatePassword" placeholder="Entrez votre mot de passe" class="input-field" />
            </n-form-item>
            <div v-if="errors.password" class="error-message">{{ errors.password }}</div>
          </div>

          <n-form-item>
            <n-button type="primary" block @click="login" class="submit-button">
              Connexion
            </n-button>
          </n-form-item>
        </n-space>
      </n-form>
    </n-card>
    <div class="signup-link">
      <p>Pas encore de compte ? <router-link to="/register">Créez-en un ici</router-link></p>
    </div>
  </div>
</template>

<script>
import { NCard, NForm, NFormItem, NInput, NButton, NSpace } from 'naive-ui';

export default {
  name: 'login',
  components: {
    NCard,
    NForm,
    NFormItem,
    NInput,
    NButton,
    NSpace
  },
  data() {
    return {
      credentials: {
        email: '',
        password: '',
      },
      errors: {
        email: '',
        password: '',
      },
    }
  },
  methods: {
    validateEmail() {
      this.errors.email = '';
      if (!this.credentials.email) {
        this.errors.email = 'Veuillez saisir votre email.';
      } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(this.credentials.email)) {
        this.errors.email = 'Email invalide.';
      }
    },
    validatePassword() {
      this.errors.password = '';
      if (!this.credentials.password) {
        this.errors.password = 'Veuillez saisir votre mot de passe.';
      }
    },
    login() {
      this.validateEmail();
      this.validatePassword();

      if (this.errors.email || this.errors.password) {
        return;
      }

      console.log('Tentative de connexion:', this.credentials);
      // Ici, vous ferez l'appel à votre backend pour la connexion
    }
  }
}
</script>

<style scoped>
.form-page {
  display: flex;
  justify-content: center;
  flex-direction: column;
  align-items: center;
  min-height: 100vh;
  background: #f4f7fb;
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
}

.input-field {
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
  padding: 12px 16px;
  font-size: 16px;
  transition: border-color 0.3s ease;
}

.input-field:focus {
  border-color: #007bff;
}

.submit-button {
  background-color: #007bff;
  border-radius: 8px;
  padding: 14px;
  font-size: 18px;
  transition: all 0.3s;
}

.submit-button:hover {
  background-color: #0056b3;
  transform: scale(1.05);
}

.submit-button:active {
  transform: scale(0.98);
}

.error-message {
  color: red;
  font-size: 14px;
  margin-top: 5px;
}

.signup-link {
  margin-top: 20px;
  text-align: center;
}

.signup-link p {
  font-size: 14px;
  color: #666;
}

@media (max-width: 768px) {
  .form-card {
    width: 90%;
    padding: 20px;
  }
}
</style>
