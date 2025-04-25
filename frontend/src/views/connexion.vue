<template>
  <div class="formulaire">
    <n-card title="Connexion">
      <n-form @submit.prevent="login" :label-width="100">
        <div class="form-control">
          <n-form-item label="Email" :error="errors.email">
            <n-input v-model="credentials.email" @input="validateEmail" placeholder="Entrez votre email" />
          </n-form-item>
          <div v-if="errors.email" class="error-message">{{ errors.email }}</div>
        </div>

        <div class="form-control">
          <n-form-item label="Mot de passe" :error="errors.password">
            <n-input type="password" v-model="credentials.password" @input="validatePassword" placeholder="Entrez votre mot de passe" />
          </n-form-item>
          <div v-if="errors.password" class="error-message">{{ errors.password }}</div>
        </div>

        <n-form-item>
          <n-button type="primary" @click="login">Connexion</n-button>
        </n-form-item>
      </n-form>
    </n-card>
  </div>
</template>

<script>
import { NCard, NForm, NFormItem, NInput, NButton } from 'naive-ui';

export default {
  name: 'login',
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
  width: 100%;
}

.n-form-item {
  margin-bottom: 0;
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