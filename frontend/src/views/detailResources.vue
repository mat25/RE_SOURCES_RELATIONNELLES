<template>
  <div class="h-screen w-screen flex items-center justify-center bg-gray-100">
    <n-card
        :title="resource.title"
        size="large"
        class="w-full max-w-xl"
    >
      <n-image
          width="100%"
          height="200"
          :src="resource.image"
          alt="Image de la ressource"
          class="rounded-lg mb-3"
          object-fit="cover"
      />

      <n-text depth="3" class="text-sm mb-2 block">
        Publié le : {{ formattedDate }}
      </n-text>

      <n-p class="mb-4">
        {{ resource.description }}
      </n-p>

      <div v-if="resource.videoUrl" class="mb-4">
        <n-button
            tag="a"
            target="_blank"
            :href="resource.videoUrl"
            type="info"
            ghost
        >
          Voir la vidéo
        </n-button>
      </div>

      <div class="flex flex-wrap gap-2">
        <n-button
            :type="isFavorite ? 'warning' : 'default'"
            @click="toggleFavorite"
        >
          {{ isFavorite ? 'Retirer des favoris' : 'Ajouter aux favoris' }}
        </n-button>

        <n-button
            :type="isWatched ? 'success' : 'default'"
            @click="toggleWatched"
        >
          {{ isWatched ? 'Déjà visionnée' : 'Marquer comme visionnée' }}
        </n-button>

        <n-button
            :type="isPrivate ? 'primary' : 'tertiary'"
            @click="togglePrivacy"
        >
          {{ isPrivate ? 'Privée' : 'Publique' }}
        </n-button>
      </div>
    </n-card>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'

const resource = {
  image: 'https://via.placeholder.com/600x300',
  title: 'Nom de la ressource',
  description: 'Voici une description complète de cette ressource utile.',
  videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
  publishedAt: '2025-04-20T14:30:00Z'
}

const isFavorite = ref(false)
const isWatched = ref(false)
const isPrivate = ref(true)

const toggleFavorite = () => {
  isFavorite.value = !isFavorite.value
}

const toggleWatched = () => {
  isWatched.value = !isWatched.value
}

const togglePrivacy = () => {
  isPrivate.value = !isPrivate.value
}

const formattedDate = computed(() => {
  const date = new Date(resource.publishedAt)
  return date.toLocaleDateString('fr-FR', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  })
})
</script>
