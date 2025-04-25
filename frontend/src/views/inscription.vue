<template>
  <div class="formulaire">
    <n-card title="Formulaire d'inscription">
      <n-form @submit.prevent="inscription" :label-width="100">
        <div class="form-control">
          <n-form-item label="Pseudo" :error="errors.pseudos.length > 0">
            <n-input v-model="credentials.pseudos" @input="validatePseudos" placeholder="Entrez votre pseudo" />
          </n-form-item>
          <div v-for="(error, index) in errors.pseudos" :key="index" class="error-message">{{ error }}</div>
        </div>

        <div class="form-control">
          <n-form-item label="Email" :error="errors.email.length > 0">
            <n-input v-model="credentials.email" @input="validateEmail" placeholder="Entrez votre email" />
          </n-form-item>
          <div v-for="(error, index) in errors.email" :key="index" class="error-message">{{ error }}</div>
        </div>

        <div class="form-control">
          <n-form-item label="Mot de passe" :error="errors.password.length > 0">
            <n-input type="password" v-model="credentials.password" @input="validatePassword" placeholder="Entrez votre mot de passe" />
          </n-form-item>
          <div v-for="(error, index) in errors.password" :key="index" class="error-message">{{ error }}</div>
        </div>

        <n-form-item>
          <n-button type="primary" @click="inscription">S'inscrire</n-button>
        </n-form-item>
      </n-form>
    </n-card>
  </div>
</template>

<script>
import { NCard, NForm, NFormItem, NInput, NButton } from 'naive-ui';

export default {
  name: 'Inscription',
  components: {
    NCard,
    NForm,
    NFormItem,
    NInput,
    NButton,
  },
  data() {
    return {
      credentials: {
        pseudos: '',
        email: '',
        password: '',
      },
      errors: {
        pseudos: [],
        email: [],
        password: [],
      },
    }
  },
  methods: {
    validatePseudos() {
      this.errors.pseudos = [];
      if (!this.credentials.pseudos) {
        this.errors.pseudos.push('Veuillez saisir un pseudo');
      }
      if (this.credentials.pseudos.length < 3) {
        this.errors.pseudos.push('Le pseudo doit avoir au moins 3 caractères');
      }
    },
    validateEmail() {
      this.errors.email = [];
      const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if (!this.credentials.email) {
        this.errors.email.push('Veuillez saisir votre email');
      }
      if (!emailPattern.test(this.credentials.email)) {
        this.errors.email.push('Email invalide');
      }
    },
    validatePassword() {
      this.errors.password = [];
      const password = this.credentials.password;
      const hasUpperCase = /[A-Z]/.test(password);
      const hasNumber = /\d/.test(password);

      if (!password) {
        this.errors.password.push('Le mot de passe est requis');
      }
      if (password.length < 6) {
        this.errors.password.push('Le mot de passe doit contenir au moins 6 caractères');
      }
      if (!hasUpperCase) {
        this.errors.password.push('Le mot de passe doit contenir au moins une majuscule');
      }
      if (!hasNumber) {
        this.errors.password.push('Le mot de passe doit contenir au moins un chiffre');
      }
    },
    inscription() {
      this.errors = {
        pseudos: [],
        email: [],
        password: [],
      };

      this.validatePseudos();
      this.validateEmail();
      this.validatePassword();

      console.log('Errors:', this.errors);

      if (this.errors.pseudos.length > 0 || this.errors.email.length > 0 || this.errors.password.length > 0) {
        console.log('Formulaire invalide');
        return false;
      } else {
        console.log('Inscription réussie:', this.credentials);
        // Ici, vous pouvez envoyer les données du formulaire à votre backend
      }
    }
  }
}
</script>

<style scoped>
.formulaire {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  margin: auto auto;
  height: 80vh;
  width: 50vw;
  padding: 20px;
  box-sizing: border-box;
}

.n-card {
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.form-control {
  margin-bottom: 15px;
  width: 100%; /* Assure que le conteneur prend toute la largeur */
}

.n-form-item {
  margin-bottom: 0; /* Supprime la marge par défaut de n-form-item */
}

.n-input {
  width: 100%;
}

.n-button {
  width: 100%;
}

.error-message {
  color: red;
  font-size: 14px;
  margin-top: 5px;
  display: block; 
  width: 100%;
  box-sizing: border-box;
}
</style>