<template>
  <div class="formulaire">
    <n-card title="Formulaire d'inscription">
      <n-form @submit.prevent="inscription" :label-width="100">
        <n-form-item label="Pseudo" :error="errors.pseudos">
          <n-input v-model="credentials.pseudos" @input="validatePseudos" placeholder="Entrez votre pseudo" />
        </n-form-item>

        <n-form-item label="Email" :error="errors.email">
          <n-input v-model="credentials.email" @input="validateEmail" placeholder="Entrez votre email" />
        </n-form-item>

        <n-form-item label="Mot de passe" :error="errors.password">
          <n-input type="password" v-model="credentials.password" @input="validatePassword" placeholder="Entrez votre mot de passe" />
        </n-form-item>

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
        pseudo: '',
        email: '',
        password: '',
      },
    }
  },
  methods: {
    validatePseudos() {
      if (!this.credentials.pseudos) {
        this.errors.pseudos = 'Veuillez saisir un pseudo';
      } else if (this.credentials.pseudos.length < 3) {
        this.errors.pseudos = 'Le pseudo doit avoir au moins 3 caractères';
      } else {
        this.errors.pseudos = '';
      }
    },
    validateEmail() {
      const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if (!this.credentials.email) {
        this.errors.email = 'Veuillez saisir votre email';
      } else if (!emailPattern.test(this.credentials.email)) {
        this.errors.email = 'Email invalide';
      } else {
        this.errors.email = '';
      }
    },
    validatePassword() {
      const password = this.credentials.password;
      const hasUpperCase = /[A-Z]/.test(password);
      const hasNumber = /\d/.test(password);

      if (!password) {
        this.errors.password = 'Le mot de passe est requis';
      } else if (password.length < 6) {
        this.errors.password = 'Le mot de passe doit contenir au moins 6 caractères';
      } else if (!hasUpperCase) {
        this.errors.password = 'Le mot de passe doit contenir au moins une majuscule';
      } else if (!hasNumber) {
        this.errors.password = 'Le mot de passe doit contenir au moins un chiffre';
      } else {
        this.errors.password = '';
      }
    },
    inscription() {
      this.errors = {
        pseudo: '',
        email: '',
        password: '',
      };

      this.validatePseudos();
      this.validateEmail();
      this.validatePassword();

      console.log('Errors:', this.errors); // Ajoute un log ici pour vérifier les erreurs après validation

      if (this.errors.pseudos || this.errors.email || this.errors.password) {
        console.log('Formulaire invalide');
        return false;
      } else {
        console.log('Inscription réussie:', this.credentials);
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

.n-form-item {
  margin-bottom: 15px;
}

.n-input {
  width: 100%;
}

.n-button {
  width: 100%;
}
</style>
