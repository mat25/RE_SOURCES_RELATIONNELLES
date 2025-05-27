<template>
  <div class="form-page">
    <n-card class="form-card" title="Connexion" size="huge">
      <n-form @submit.prevent.native="handleSubmit" :label-width="100">
        <n-space vertical size="large">
          <div class="form-control">
            <n-form-item
              label="Nom d'utilisateur"
              :validation-status="usernameStatus"
              :feedback="errors.username"
            >
              <n-input
                v-model="credentials.username"
                placeholder="Entrez votre nom d'utilisateur"
                class="input-field"
                @focus="clearError('username')"
              />
            </n-form-item>
          </div>

          <div class="form-control">
            <n-form-item
              label="Mot de passe"
              :validation-status="passwordStatus"
              :feedback="errors.password"
            >
              <n-input
                type="password"
                v-model="credentials.password"
                placeholder="Entrez votre mot de passe"
                class="input-field"
                @focus="clearError('password')"
              />
            </n-form-item>
          </div>

          <n-form-item>
            <n-button type="primary" block attr-type="submit" :loading="loading" class="submit-button">
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
import { NCard, NForm, NFormItem, NInput, NButton, NSpace, useMessage } from 'naive-ui';
import axios from 'axios';

export default {
  name: 'Login',
  components: {
    NCard,
    NForm,
    NFormItem,
    NInput,
    NButton,
    NSpace
  },
  setup() {
    const message = useMessage();
    return { message };
  },
  data() {
    return {
      credentials: {
        username: '',
        password: ''
      },
      errors: {
        username: '',
        password: ''
      },
      loading: false,
      formSubmitted: false // ⚠️ Ajouté pour contrôler l'affichage des erreurs
    };
  },
  computed: {
    usernameStatus() {
      return this.formSubmitted && this.errors.username ? 'error' : undefined;
    },
    passwordStatus() {
      return this.formSubmitted && this.errors.password ? 'error' : undefined;
    }
  },
  methods: {
    validateForm() {
      let isValid = true;

      if (!this.credentials.username.trim()) {
        this.errors.username = "Le nom d'utilisateur est requis.";
        isValid = false;
      } else if (this.credentials.username.trim().length < 3) {
        this.errors.username = "Le nom d'utilisateur doit contenir au moins 3 caractères.";
        isValid = false;
      } else {
        this.errors.username = '';
      }

      if (!this.credentials.password.trim()) {
        this.errors.password = 'Le mot de passe est requis.';
        isValid = false;
      } else if (this.credentials.password.trim().length < 6) {
        this.errors.password = 'Le mot de passe doit contenir au moins 6 caractères.';
        isValid = false;
      } else {
        this.errors.password = '';
      }

      return isValid;
    },

    clearError(field) {
      if (this.formSubmitted && this.errors[field]) {
        this.errors[field] = '';
      }
    },

    async handleSubmit() {
      this.formSubmitted = true; // ⚠️ On active les erreurs visibles

      const isValid = this.validateForm();

      if (!isValid) {
        this.message.error('Veuillez corriger les erreurs dans le formulaire.');
        return;
      }

      this.loading = true;

      try {
        const response = await axios.post('/api/login', {
          username: this.credentials.username.trim(),
          password: this.credentials.password.trim()
        });

        localStorage.setItem('token', response.data.token);

        this.message.success('Connexion réussie !');
        this.$router.push('/');
      } catch (error) {
        if (error.response) {
          const status = error.response.status;
          if (status === 401 || status === 400) {
            this.errors.password = "Nom d'utilisateur ou mot de passe incorrect.";
            this.message.error("Nom d'utilisateur ou mot de passe incorrect.");
          } else if (status === 404) {
            this.message.error('Le service de connexion est indisponible (Erreur 404).');
          } else {
            this.message.error('Une erreur serveur est survenue.');
          }
        } else {
          this.message.error("Impossible de se connecter au serveur.");
        }
      } finally {
        this.loading = false;
      }
    }
  }
};
</script>


<style scoped>
/* Le style reste inchangé */
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

/* Le message d'erreur est géré par n-form-item feedback */
/* .error-message {
  color: red;
  font-size: 14px;
  margin-top: 5px;
} */

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