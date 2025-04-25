<template>
  <div class="formulaire">
    <n-card title="Formulaire d'inscription">
      <n-form @submit.prevent="submitInscription" :label-width="120">
        <div class="form-control">
          <n-form-item label="Prénom" :error="errors.firstName.length > 0">
            <n-input v-model="credentials.firstName" @input="validateFirstName" placeholder="Entrez votre prénom" />
          </n-form-item>
          <div v-for="(error, index) in errors.firstName" :key="index" class="error-message">{{ error }}</div>
        </div>

        <div class="form-control">
          <n-form-item label="Nom" :error="errors.lastName.length > 0">
            <n-input v-model="credentials.lastName" @input="validateLastName" placeholder="Entrez votre nom" />
          </n-form-item>
          <div v-for="(error, index) in errors.lastName" :key="index" class="error-message">{{ error }}</div>
        </div>

        <div class="form-control">
          <n-form-item label="Pseudo" :error="errors.username.length > 0">
            <n-input v-model="credentials.username" @input="validateUsername" placeholder="Entrez votre pseudo" />
          </n-form-item>
          <div v-for="(error, index) in errors.username" :key="index" class="error-message">{{ error }}</div>
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
          <n-button type="primary" :loading="isSubmitting" @click="submitInscription">
            {{ isSubmitting ? 'Inscription en cours...' : 'S\'inscrire' }}
          </n-button>
        </n-form-item>
      </n-form>
    </n-card>
  </div>
</template>

<script>
import { NCard, NForm, NFormItem, NInput, NButton, useMessage } from 'naive-ui';
import axios from 'axios';
import { ref } from 'vue';

export default {
  name: 'Inscription',
  components: {
    NCard,
    NForm,
    NFormItem,
    NInput,
    NButton,
  },
  setup() {
    const message = useMessage();
    const isSubmitting = ref(false);
    const credentials = ref({
      firstName: '',
      lastName: '',
      username: '',
      email: '',
      password: '',
    });
    const errors = ref({
      firstName: [],
      lastName: [],
      username: [],
      email: [],
      password: [],
    });

    const validateFirstName = () => {
      errors.value.firstName = [];
      if (!credentials.value.firstName) {
        errors.value.firstName.push('Veuillez saisir votre prénom');
      }
    };

    const validateLastName = () => {
      errors.value.lastName = [];
      if (!credentials.value.lastName) {
        errors.value.lastName.push('Veuillez saisir votre nom');
      }
    };

    const validateUsername = () => {
      errors.value.username = [];
      if (!credentials.value.username) {
        errors.value.username.push('Veuillez saisir un pseudo');
      }
      if (credentials.value.username.length < 3) {
        errors.value.username.push('Le pseudo doit avoir au moins 3 caractères');
      }
    };

    const validateEmail = () => {
      errors.value.email = [];
      const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if (!credentials.value.email) {
        errors.value.email.push('Veuillez saisir votre email');
      }
      if (!emailPattern.test(credentials.value.email)) {
        errors.value.email.push('Email invalide');
      }
    };

    const validatePassword = () => {
      errors.value.password = [];
      const password = credentials.value.password;
      const hasUpperCase = /[A-Z]/.test(password);
      const hasNumber = /\d/.test(password);

      if (!password) {
        errors.value.password.push('Le mot de passe est requis');
      }
      if (password.length < 6) {
        errors.value.password.push('Le mot de passe doit contenir au moins 6 caractères');
      }
      if (!hasUpperCase) {
        errors.value.password.push('Le mot de passe doit contenir au moins une majuscule');
      }
      if (!hasNumber) {
        errors.value.password.push('Le mot de passe doit contenir au moins un chiffre');
      }
    };

    const submitInscription = async () => {
      errors.value = {
        firstName: [],
        lastName: [],
        username: [],
        email: [],
        password: [],
      };

      validateFirstName();
      validateLastName();
      validateUsername();
      validateEmail();
      validatePassword();

      if (
        errors.value.firstName.length > 0 ||
        errors.value.lastName.length > 0 ||
        errors.value.username.length > 0 ||
        errors.value.email.length > 0 ||
        errors.value.password.length > 0
      ) {
        message.error('Veuillez corriger les erreurs du formulaire.');
        return;
      }

      isSubmitting.value = true;

      try {
        const apiUrl = 'http://localhost:8080/register'; 
        const response = await axios.post(apiUrl, {
          firstName: credentials.value.firstName,
          lastName: credentials.value.lastName,
          username: credentials.value.username,
          email: credentials.value.email,
          password: credentials.value.password,
        });

        if (response.status >= 200 && response.status < 300) {
          message.success('Inscription réussie ! Vous pouvez maintenant vous connecter.');
          credentials.value = { firstName: '', lastName: '', username: '', email: '', password: '' };
        } else {
          console.error('Erreur lors de l\'inscription:', response.data);
          message.error('Erreur lors de l\'inscription. Veuillez réessayer.');
          if (response.data && response.data.errors) {
            errors.value = { ...errors.value, ...response.data.errors };
          }
        }
      } catch (error) {
        console.error('Erreur de communication avec le serveur:', error);
        message.error('Erreur de communication avec le serveur. Veuillez réessayer plus tard.');
        // if (error.response) {
        //   console.error('Réponse du serveur:', error.response.data);
        //   console.error('Statut de la réponse:', error.response.status);
        //   console.error('Headers de la réponse:', error.response.headers);
        // } else if (error.request) {
        //   console.error('Pas de réponse reçue du serveur:', error.request);
        // } else {
        //   console.error('Erreur lors de la configuration de la requête:', error.message);
        // }
      } finally {
        isSubmitting.value = false;
      }
    };

    return {
      credentials,
      errors,
      validateFirstName,
      validateLastName,
      validateUsername,
      validateEmail,
      validatePassword,
      submitInscription,
      isSubmitting,
      message,
    };
  },
};
</script>

<style scoped>
.formulaire {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  margin: 50px auto;
  width: 40vw;
  padding: 30px;
  box-sizing: border-box;
  min-width: 300px;
}

.n-card {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  border-radius: 8px;
  padding: 30px;
  width: 100%;
}

.form-control {
  margin-bottom: 20px;
  width: 100%;
}

.n-form-item {
  margin-bottom: 0;
}

.n-input {
  width: 100%;
  border-radius: 6px;
}

.n-button {
  width: 100%;
  border-radius: 6px;
  padding: 12px 20px;
  font-size: 16px;
}

.error-message {
  color: #e74c3c;
  font-size: 14px;
  margin-top: 8px;
  display: block;
  width: 100%;
  box-sizing: border-box;
}

@media (max-width: 768px) {
  .formulaire {
    width: 80vw;
    margin: 30px auto;
  }
}
</style>