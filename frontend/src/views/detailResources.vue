<template>
  <div class="min-h-screen flex items-center justify-center bg-gray-100 p-6">
    <n-card size="large" class="w-full max-w-4xl bg-white rounded-xl shadow-2xl p-8">
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

      <n-image
          width="100%"
          height="300"
          :src="resource.image"
          alt="Image de la ressource"
          class="rounded-lg mb-4 shadow-lg"
          object-fit="cover"
      />

      <n-text class="text-lg text-gray-800 mb-4">
        {{ resource.description }}
      </n-text>

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

        <n-button @click="toggleShareModal" type="info" class="transition-all duration-300 transform hover:scale-105">
          Partager
        </n-button>
      </div>

      <div v-if="isShareModalVisible" class="fixed inset-0 bg-black bg-opacity-50 flex justify-center items-center z-50">
        <div class="bg-white p-8 rounded-lg shadow-xl w-80 text-center">
          <h2 class="text-xl font-semibold mb-4">Partager cette ressource</h2>
          <div class="flex justify-center gap-6 mb-4">
            <n-button
                tag="a"
                target="_blank"
                :href="'https://www.facebook.com/sharer/sharer.php?u=' + shareUrl"
                type="primary"
                class="rounded-full p-4"
            >
              <n-icon size="24" class="text-white">
                 <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 320 512"><path fill="currentColor" d="M279.1 288c9.4 0 17-7.6 17-17v-49.1c0-9.4-7.6-17-17-17H256v-32c0-35.3-28.7-64-64-64h-32C124.7 112 96 140.7 96 176v32H73c-9.4 0-17 7.6-17 17v49.1c0 9.4 7.6 17 17 17h23v96c0 17.7 14.3 32 32 32h64c17.7 0 32-14.3 32-32V288h23.1zM32 32C14.3 32 0 46.3 0 64v384c0 17.7 14.3 32 32 32H288c17.7 0 32-14.3 32-32V64c0-17.7-14.3-32-32-32H32z"/></svg>
                      </n-icon>
                    </n-button>

            <n-button
                tag="a"
                target="_blank"
                :href="'https://twitter.com/intent/tweet?url=' + shareUrl"
                type="info"
                class="rounded-full p-4"
            >
              <n-icon size="24" class="text-white">
                 <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512"><path fill="currentColor" d="M459.4 151.7c.3 4.5 .3 9 0 13.5c0 149.1-114.1 321.1-321.1 321.1-63.1 0-121.3-18.8-171.5-51.7c9.7 1.1 19.5 1.7 29.6 1.7 56.6 0 107.9-19.1 148.7-51.1-8.8-.2-16.1-3-22.8-7.7c8.1 1.5 16.7 2.3 25.5 2.3 4.9 0 9.6-.4 14.1-1.1-8.4-1.7-14.3-5.7-17.4-10.7c4.1.8 8.5 1.3 13 1.3 2.6 0 5.1-.2 7.5-.6-8.1-1.6-14.3-8.8-14.3-17.6v-.2c2.8 1.6 6.1 2.5 9.7 2.5 1.9 0 3.7-.2 5.5-.5-8.4-1.6-14.3-8.6-14.3-17.4 0-1.9.5-3.7 1.4-5.2 10.1 12.6 25.5 20.1 42.1 20.8-12.2-.4-23.3-3.7-32-9.5c0-2.1.5-4.1 1.4-5.9 16.7 21.4 42 34 70.3 35.2-3.3-.8-6.8-1.3-10.4-1.3-6.1 0-11.6.4-16.8 1.1 23.4 0 44.3-7.9 60.1-21.4-8-1.6-14.8-4-20.6-7.2z"/></svg>
                      </n-icon>
                    </n-button>

            <n-button
                tag="a"
                target="_blank"
                :href="'https://www.linkedin.com/shareArticle?mini=true&url=' + shareUrl"
                type="primary"
                class="rounded-full p-4"
            >
              <n-icon size="24" class="text-white">
                 <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512"><path fill="currentColor" d="M416 32H32C14.3 32 0 46.3 0 64v384c0 17.7 14.3 32 32 32h384c17.7 0 32-14.3 32-32V64c0-17.7-14.3-32-32-32zM137.9 320h-30.6v128h30.6v-128zm-15.3-97.1c10.3 0 18.6-8.3 18.6-18.6 0-10.3-8.3-18.6-18.6-18.6-10.3 0-18.6 8.3-18.6 18.6 0 10.3 8.3 18.6 18.6 18.6zM272 320h-30.6v128h30.6v-68.8c0-39.2 19.7-58.4 57.1-58.4 41.6 0 57.1 30.2 57.1 58.4V448h30.6V320c0-67.4-38.1-100.4-92.8-100.4-50.5 0-79.4 32.8-79.4 32.8z"/></svg>
                      </n-icon>
                    </n-button>
          </div>
          <n-button @click="toggleShareModal" type="error" class="w-full">
            Fermer
          </n-button>
        </div>
      </div>

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

      <div class="mt-6">
        <h3 class="text-2xl font-semibold text-gray-900 mb-4">Commentaires</h3>
        <div v-for="(comment, index) in comments" :key="index" class="p-4 bg-gray-50 rounded-lg shadow-sm mb-4">
          <p class="text-lg text-gray-700">{{ comment.text }}</p>

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
        image: 'https://images.unsplash.com/photo-1541414434078-61d904b17498?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90b3wtfHx8fHx8Mnx8fHw',
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