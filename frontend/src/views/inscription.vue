<template>
  <div class="form-container">
    <n-card title="Inscription">
      <n-form
          ref="formRef"
          :model="form"
          :rules="rules"
          label-placement="top"
          size="large"
      >
        <n-form-item label="Nom" path="name">
          <n-input v-model:value="form.name" placeholder="Entrez votre nom" />
        </n-form-item>

        <n-form-item label="Email" path="email">
          <n-input
              v-model:value="form.email"
              type="email"
              placeholder="Entrez votre email"
          />
        </n-form-item>

        <n-form-item label="Mot de passe" path="password">
          <n-input
              v-model:value="form.password"
              type="password"
              placeholder="Entrez un mot de passe"
              show-password-on="mousedown"
          />
        </n-form-item>

        <n-form-item label="Confirmer le mot de passe" path="confirmPassword">
          <n-input
              v-model:value="form.confirmPassword"
              type="password"
              placeholder="Confirmez votre mot de passe"
              show-password-on="mousedown"
          />
        </n-form-item>

        <n-form-item>
          <n-button type="primary" @click="handleSubmit">S'inscrire</n-button>
        </n-form-item>
      </n-form>
    </n-card>
  </div>
</template>

<script setup>
import { ref } from "vue";
import { useMessage } from "naive-ui";

const message = useMessage();
const formRef = ref(null);

const form = ref({
  name: "",
  email: "",
  password: "",
  confirmPassword: "",
});

const rules = {
  email: [
    {
      required: true,
      message: "L'email est obligatoire",
      trigger: "blur",
    },
    {
      type: "email",
      message: "Veuillez entrer un email valide",
      trigger: "blur",
    },
  ],
  password: [
    {
      required: true,
      message: "Le mot de passe est obligatoire",
      trigger: "blur",
    },
    {
      min: 6,
      message: "Le mot de passe doit avoir au moins 6 caractères",
      trigger: "blur",
    },
  ],
  confirmPassword: [
    {
      required: true,
      message: "Veuillez confirmer votre mot de passe",
      trigger: "blur",
    },
    {
      validator: (rule, value) => {
        return value === form.value.password;
      },
      message: "Les mots de passe ne correspondent pas",
      trigger: "blur",
    },
  ],
};

const handleSubmit = () => {
  formRef.value?.validate((errors) => {
    if (!errors) {
      message.success("Inscription réussie !");
    } else {
      message.error("Veuillez corriger les erreurs.");
    }
  });
};
</script>

<style scoped>
.form-container {
  max-width: 400px;
  margin: 50px auto;
}

.n-card {
  padding: 20px;
}

n-form-item {
  margin-bottom: 16px;
}

.n-button {
  display: block;
  width: 100%;
}
</style>
