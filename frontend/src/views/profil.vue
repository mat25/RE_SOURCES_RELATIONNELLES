<template>
  <div class="profile-container">
    <n-card :hoverable="true" class="profile-card">
      <n-space align="center">
        <n-avatar
            round
            size="100"
            src="https://randomuser.me/api/portraits/men/1.jpg"
        />

        <div class="profile-info">
          <p><strong>Nom :</strong> Doe</p>
          <p><strong>Prénom :</strong> John</p>
          <p><strong>Email :</strong> john.doe@example.com</p>
          <p><strong>Date inscrition :</strong> 11/04/2025</p>
          <p><strong>Mot de passe :</strong> ********
            <n-button text @click="showPasswordModal">Modifier</n-button>
          </p>
        </div>
      </n-space>

      <n-space justify="center" style="margin-top: 20px;">
        <n-button type="primary" @click="editProfile">Modifier</n-button>
        <n-button @click="viewSettings">Paramètres</n-button>
      </n-space>
    </n-card>

    <n-modal v-model:show="showModal" preset="card" title="Modifier le mot de passe">
      <n-form @submit.prevent="changePassword">
        <n-form-item label="Votre ancien mot de passe">
          <n-input type="password" v-model="lastPassword" placeholder="Entrez votre ancien mot de passe" />
        </n-form-item>
        <n-form-item label="Nouveau mot de passe">
          <n-input type="password" v-model="newPassword" placeholder="Entrez un nouveau mot de passe" />
        </n-form-item>
        <n-form-item label="Confirmer le mot de passe">
          <n-input type="password" v-model="confirmPassword" placeholder="Confirmez le mot de passe" />
        </n-form-item>
        <p v-if="passwordError" class="error">{{ passwordError }}</p>
        <n-space justify="end">
          <n-button @click="showModal = false">Annuler</n-button>
          <n-button type="primary" @click="changePassword">Enregistrer</n-button>
        </n-space>
      </n-form>
    </n-modal>
  </div>
</template>

<script>
export default {
  name: 'ProfilePage',
  data() {
    return {
      showModal: false,
      lastPassword: '',
      newPassword: '',
      confirmPassword: '',
      passwordError: ''
    };
  },
  methods: {
    editProfile() {
      console.log('Modification du profil');
    },
    viewSettings() {
      console.log('Ouverture des paramètres');
    },
    showPasswordModal() {
      this.showModal = true;
    },
    changePassword() {
      if (!this.newPassword) {
        this.passwordError = "Le mot de passe est requis.";
        return;
      }
      if (this.newPassword.length < 6) {
        this.passwordError = "Le mot de passe doit contenir au moins 6 caractères.";
        return;
      }
      if (!/[A-Z]/.test(this.newPassword)) {
        this.passwordError = "Le mot de passe doit contenir au moins une majuscule.";
        return;
      }
      if (!/\d/.test(this.newPassword)) {
        this.passwordError = "Le mot de passe doit contenir au moins un chiffre.";
        return;
      }
      if (this.newPassword !== this.confirmPassword) {
        this.passwordError = "Les mots de passe ne correspondent pas.";
        return;
      }

      this.passwordError = '';
      this.showModal = false;
      console.log("Mot de passe changé avec succès !");
    }
  }
};
</script>

<style scoped>
.profile-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
}

.profile-card {
  width: 500px;
  padding: 20px;
}

.profile-info {
  margin-left: 20px;
}

.profile-info p {
  margin: 5px 0;
}

.error {
  color: red;
  font-size: 14px;
}
</style>
