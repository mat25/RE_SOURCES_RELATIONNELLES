<template>
  <div class="formulaire">
    <n-card title="Connexion">
      <n-form @submit.prevent="login" :label-width="100">

        <n-form-item label="Email" :error="errors.email">
          <n-input v-model="credentials.email" @input="validateEmail" placeholder="Entrez votre email" />
        </n-form-item>

        <n-form-item label="Mot de passe" :error="errors.password">
          <n-input type="password" v-model="credentials.password" @input="validatePassword" placeholder="Entrez votre mot de passe" />
        </n-form-item>

        <n-form-item>
          <n-button type="primary" @click="login">connexion</n-button>
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
    login() {
      this.errors = {
        pseudo: '',
        email: '',
        password: '',
      };

      // a faire quand le back sera fais

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
