<template>
  <div class="min-h-screen flex items-center justify-center bg-gradient-to-r from-gray-200 via-gray-300 to-gray-400 p-6">
    <n-card size="large" class="w-full max-w-4xl bg-white rounded-xl shadow-2xl p-8">
      <!-- Header avec bouton favoris -->
      <template #header>
        <div class="flex items-center justify-between">
          <div class="flex flex-col">
            <h1 class="text-4xl font-bold text-gray-900">{{ resource.title }}</h1>
            <p class="text-xl text-gray-600">{{ formattedDate }}</p>
          </div>
          <n-button quaternary @click="toggleFavorite">
            <n-icon :color="isFavorite ? 'blue' : 'gray'" size="24">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
                <path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/>
              </svg>
            </n-icon>
          </n-button>
        </div>
      </template>

      <!-- Image de la ressource -->
      <n-image
          width="100%"
          height="300"
          :src="resource.image"
          alt="Image de la ressource"
          class="rounded-lg mb-4 shadow-lg"
          object-fit="cover"
      />

      <!-- Description -->
      <n-text class="text-lg text-gray-800 mb-4">
        {{ resource.description }}
      </n-text>

      <!-- Section vidéo -->
      <div v-if="resource.videoUrl" class="mb-6">
        <n-button
            tag="a"
            target="_blank"
            :href="resource.videoUrl"
            type="info"
            ghost
            class="text-lg font-semibold"
        >
          Voir la vidéo
        </n-button>
      </div>

      <!-- Section d'action -->
      <div class="flex flex-wrap gap-4">
        <n-button
            :type="isWatched ? 'success' : 'default'"
            @click="toggleWatched"
            class="transition-all duration-300 transform hover:scale-105"
        >
          {{ isWatched ? 'Déjà visionnée' : 'Marquer comme visionnée' }}
        </n-button>

        <n-button
            :type="isPrivate ? 'primary' : 'tertiary'"
            @click="togglePrivacy"
            class="transition-all duration-300 transform hover:scale-105"
        >
          {{ isPrivate ? 'Privée' : 'Publique' }}
        </n-button>

        <!-- Bouton de partage -->
        <n-button @click="toggleShareModal" type="info" class="transition-all duration-300 transform hover:scale-105">
          Partager
        </n-button>
      </div>

      <!-- Modal de partage (popup) -->
      <div v-if="isShareModalVisible" class="fixed inset-0 bg-black bg-opacity-50 flex justify-center items-center z-50">
        <div class="bg-white p-8 rounded-lg shadow-xl w-80 text-center">
          <h2 class="text-xl font-semibold mb-4">Partager cette ressource</h2>
          <div class="flex justify-center gap-6 mb-4">
            <!-- Facebook -->
            <n-button
                tag="a"
                target="_blank"
                :href="'https://www.facebook.com/sharer/sharer.php?u=' + shareUrl"
                type="success"
                class="rounded-full p-4"
            >
              <n-icon size="24" class="text-white">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
                  <path d="M13 2H11V7H7V9H11V13H9V17H13V13H15V9H13V2Z"/>
                </svg>
              </n-icon>
            </n-button>

            <!-- Twitter -->
            <n-button
                tag="a"
                target="_blank"
                :href="'https://twitter.com/intent/tweet?url=' + shareUrl"
                type="info"
                class="rounded-full p-4"
            >
              <n-icon size="24" class="text-white">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
                  <path d="M23 3a10.9 10.9 0 0 1-3.14.87A5.47 5.47 0 0 0 22.47 2c-2.11 1.24-3.33 2.02-5.13 2.49A5.47 5.47 0 0 0 16.6 1C14.35 1 12.5 2.91 12.5 4.5c0 .39.07.76.19 1.11C7.69 5.98 4.07 4.07 2 1.2A4.54 4.54 0 0 0 1 3c0 1.57.8 2.95 2 3.78A5.47 5.47 0 0 1 1 8v.08A5.47 5.47 0 0 0 3.1 12.9a5.47 5.47 0 0 1-2-.55v.05c0 2.11 1.51 3.88 3.51 4.3a5.49 5.49 0 0 1-2.44.1c.7 2.17 2.69 3.77 5.06 3.77a10.93 10.93 0 0 0 11-11V3z"/>
                </svg>
              </n-icon>
            </n-button>

            <!-- LinkedIn -->
            <n-button
                tag="a"
                target="_blank"
                :href="'https://www.linkedin.com/shareArticle?mini=true&url=' + shareUrl"
                type="primary"
                class="rounded-full p-4"
            >
              <n-icon size="24" class="text-white">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
                  <path d="M4.98 3.5C4.98 2.12 5.98 1 7.2 1c1.22 0 2.22 1.12 2.22 2.5 0 1.38-1 2.5-2.22 2.5-1.22 0-2.22-1.12-2.22-2.5zm-.24 7.5h4.47V9.75h-2.73V7.38h2.73V5.98C9.47 4.59 8.22 4 7.37 4c-.86 0-1.61.2-2.28.61-.35-.13-.68-.3-.98-.48-1.47-.91-2.76 1.13-2.76 3.04v3.13h-2.7v3.56h2.7v10.72h4.46V11.5z"/>
                </svg>
              </n-icon>
            </n-button>
          </div>
          <n-button @click="toggleShareModal" type="error" class="w-full">
            Fermer
          </n-button>
        </div>
      </div>

      <!-- Espace commentaire -->
      <div class="mt-8">
        <h3 class="text-2xl font-semibold text-gray-900 mb-4">Ajouter un commentaire</h3>
        <n-input
            v-model="newComment"
            type="textarea"
            placeholder="Écrivez votre commentaire..."
            class="border-2 border-gray-300 rounded-lg p-4 w-full"
            rows="4"
        ></n-input>
        <div class="mt-4 text-right">
          <n-button @click="addComment" type="success">Envoyer</n-button>
        </div>
      </div>

      <!-- Liste des commentaires -->
      <div class="mt-6">
        <h3 class="text-2xl font-semibold text-gray-900 mb-4">Commentaires</h3>
        <div v-for="(comment, index) in comments" :key="index" class="p-4 bg-gray-50 rounded-lg shadow-sm mb-4">
          <p class="text-lg text-gray-700">{{ comment.text }}</p>

          <!-- Si l'utilisateur est un modérateur, afficher le bouton de suppression -->
          <div v-if="isModerator" class="flex justify-end mt-2">
            <n-button @click="deleteComment(index)" type="error" size="small">Supprimer</n-button>
          </div>
        </div>
      </div>
    </n-card>
  </div>
</template>

<script>
export default {
  data() {
    return {
      resource: {
        title: 'Exemple de ressource',
        description: 'Voici une ressource intéressante que vous pouvez partager et commenter.',
        image: '/m3gtr.webp',
        videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
      },
      isFavorite: false,
      isWatched: false,
      isPrivate: false,
      isShareModalVisible: false,
      newComment: '',
      comments: [],
      isModerator: true,
    };
  },
  computed: {
    shareUrl() {
      return encodeURIComponent(window.location.href);
    },
    formattedDate() {
      return new Date().toLocaleDateString();
    },
  },
  methods: {
    toggleFavorite() {
      this.isFavorite = !this.isFavorite;
    },
    toggleWatched() {
      this.isWatched = !this.isWatched;
    },
    togglePrivacy() {
      this.isPrivate = !this.isPrivate;
    },
    toggleShareModal() {
      this.isShareModalVisible = !this.isShareModalVisible;
    },
    addComment() {
      if (this.newComment) {
        this.comments.push({ text: this.newComment });
        this.newComment = '';
      }
    },
    deleteComment(index) {
      this.comments.splice(index, 1);
    },
  },
};
</script>

<style scoped>
.fixed {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
}

.bg-opacity-50 {
  background-color: rgba(0, 0, 0, 0.5);
}

.z-50 {
  z-index: 50;
}

.rounded-full {
  border-radius: 50%;
}

.p-4 {
  padding: 1rem;
}

/* Style du modal */
.bg-white {
  background-color: white;
}

.shadow-xl {
  box-shadow: 0 10px 15px rgba(0, 0, 0, 0.1);
}

.w-80 {
  width: 20rem;
}

.text-center {
  text-align: center;
}

.mb-4 {
  margin-bottom: 1rem;
}

/* Couleur des icônes dans les boutons circulaires */
.text-white {
  color: white;
}

.n-button {
  margin: 0.5rem;
}
</style>
