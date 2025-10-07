<template>
  <div class="min-h-screen bg-gray-50">
    <!-- Loading State -->
    <LoadingSpinner v-if="loading" message="Loading meal details..." />

    <!-- Error State -->
    <div v-else-if="error" class="p-8">
      <ErrorMessage :message="error" @retry="fetchMealDetails" />
    </div>

    <!-- Meal Details -->
    <div v-else-if="meal" class="pb-12">
      <!-- Hero Section -->
      <div class="relative h-64 md:h-96 overflow-hidden">
        <img :src="meal.strMealThumb" :alt="meal.strMeal" class="w-full h-full object-cover" />
        <div
          class="absolute inset-0 bg-gradient-to-t from-black/70 via-black/20 to-transparent"
        ></div>

        <!-- Back Button -->
        <button
          @click="$router.back()"
          class="absolute top-4 left-4 z-10 p-2 bg-white/20 backdrop-blur-sm rounded-full hover:bg-white/30 transition-colors duration-200"
        >
          <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M15 19l-7-7 7-7"
            ></path>
          </svg>
        </button>

        <!-- Title and Meta -->
        <div class="absolute bottom-0 left-0 right-0 p-6">
          <div class="max-w-7xl mx-auto">
            <h1 class="text-3xl md:text-5xl font-bold text-white mb-2">{{ meal.strMeal }}</h1>
            <div class="flex flex-wrap gap-3">
              <span class="bg-orange-500 text-white px-3 py-1 rounded-full text-sm font-semibold">
                {{ meal.strCategory }}
              </span>
              <span
                v-if="meal.strArea"
                class="bg-blue-500 text-white px-3 py-1 rounded-full text-sm font-semibold"
              >
                {{ meal.strArea }}
              </span>
              <span
                v-if="meal.strTags"
                class="bg-green-500 text-white px-3 py-1 rounded-full text-sm font-semibold"
              >
                {{ meal.strTags }}
              </span>
            </div>
          </div>
        </div>
      </div>

      <!-- Content -->
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-12">
          <!-- Main Content -->
          <div class="lg:col-span-2">
            <!-- Instructions -->
            <div class="bg-white rounded-xl shadow-lg p-6 mb-8">
              <h2 class="text-2xl font-bold text-gray-800 mb-4 flex items-center">
                <svg
                  class="w-6 h-6 mr-2 text-orange-500"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"
                  ></path>
                </svg>
                Instructions
              </h2>
              <div class="prose max-w-none">
                <p class="text-gray-700 leading-relaxed whitespace-pre-line">
                  {{ meal.strInstructions }}
                </p>
              </div>
            </div>

            <!-- Video (if available) -->
            <div v-if="meal.strYoutube" class="bg-white rounded-xl shadow-lg p-6">
              <h2 class="text-2xl font-bold text-gray-800 mb-4 flex items-center">
                <svg class="w-6 h-6 mr-2 text-red-500" fill="currentColor" viewBox="0 0 24 24">
                  <path
                    d="M21.593 7.203a2.506 2.506 0 0 0-1.762-1.766C18.265 5.007 12 5 12 5s-6.264-.007-7.831.404a2.56 2.56 0 0 0-1.766 1.778c-.413 1.566-.417 4.814-.417 4.814s-.004 3.264.406 4.814c.23.857.905 1.534 1.763 1.765 1.582.43 7.83.437 7.83.437s6.265.007 7.831-.403a2.515 2.515 0 0 0 1.767-1.763c.414-1.565.417-4.812.417-4.812s.02-3.265-.407-4.831zM9.996 15.005l.005-6 5.207 3.005-5.212 2.995z"
                  />
                </svg>
                Video Tutorial
              </h2>
              <div class="relative pb-56.25% h-0 overflow-hidden rounded-lg">
                <iframe
                  :src="youtubeEmbedUrl"
                  class="absolute top-0 left-0 w-full h-full"
                  frameborder="0"
                  allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                  allowfullscreen
                ></iframe>
              </div>
            </div>
          </div>

          <!-- Sidebar -->
          <div class="lg:col-span-1">
            <!-- Ingredients -->
            <div class="bg-white rounded-xl shadow-lg p-6 mb-8">
              <h2 class="text-2xl font-bold text-gray-800 mb-4 flex items-center">
                <svg
                  class="w-6 h-6 mr-2 text-green-500"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M9 5H7a2 2 0 00-2 2v6a2 2 0 002 2h2m0-8v8m0-8h8a2 2 0 012 2v6a2 2 0 01-2 2h-8"
                  ></path>
                </svg>
                Ingredients
              </h2>
              <ul class="space-y-3">
                <li
                  v-for="ingredient in ingredients"
                  :key="ingredient.name"
                  class="flex items-center justify-between py-2 border-b border-gray-100 last:border-0"
                >
                  <span class="text-gray-700 font-medium">{{ ingredient.name }}</span>
                  <span class="text-gray-500 text-sm">{{ ingredient.measure }}</span>
                </li>
              </ul>
            </div>

            <!-- Quick Links -->
            <div class="bg-white rounded-xl shadow-lg p-6">
              <h3 class="text-lg font-semibold text-gray-800 mb-4">Quick Links</h3>
              <div class="space-y-3">
                <router-link
                  :to="`/category/${meal.strCategory}`"
                  class="flex items-center justify-between p-3 rounded-lg hover:bg-gray-50 transition-colors duration-200 group"
                >
                  <div class="flex items-center">
                    <svg
                      class="w-5 h-5 mr-2 text-orange-500"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M7 7h.01M7 3h5c.512 0 1.024.195 1.414.586l7 7a2 2 0 010 2.828l-7 7a2 2 0 01-2.828 0l-7-7A1.994 1.994 0 013 12V7a4 4 0 014-4z"
                      ></path>
                    </svg>
                    <span class="text-gray-700">More {{ meal.strCategory }}</span>
                  </div>
                  <svg
                    class="w-4 h-4 text-gray-400 group-hover:text-gray-600"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M9 5l7 7-7 7"
                    ></path>
                  </svg>
                </router-link>

                <button
                  @click="getRandomMeal"
                  class="w-full flex items-center justify-between p-3 rounded-lg hover:bg-gray-50 transition-colors duration-200 group"
                >
                  <div class="flex items-center">
                    <svg
                      class="w-5 h-5 mr-2 text-purple-500"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"
                      ></path>
                    </svg>
                    <span class="text-gray-700">Random Meal</span>
                  </div>
                  <svg
                    class="w-4 h-4 text-gray-400 group-hover:text-gray-600"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M9 5l7 7-7 7"
                    ></path>
                  </svg>
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { mealService } from '../services/api'
import LoadingSpinner from '../components/LoadingSpinner.vue'
import ErrorMessage from '../components/ErrorMessage.vue'

const route = useRoute()
const router = useRouter()
const loading = ref(false)
const error = ref('')
const meal = ref(null)

const ingredients = computed(() => {
  if (!meal.value) return []

  const ingredientList = []
  for (let i = 1; i <= 20; i++) {
    const ingredient = meal.value[`strIngredient${i}`]
    const measure = meal.value[`strMeasure${i}`]

    if (ingredient && ingredient.trim()) {
      ingredientList.push({
        name: ingredient.trim(),
        measure: measure ? measure.trim() : '',
      })
    }
  }

  return ingredientList
})

const youtubeEmbedUrl = computed(() => {
  if (!meal.value?.strYoutube) return ''

  const videoId = meal.value.strYoutube.split('v=')[1]?.split('&')[0]
  return `https://www.youtube.com/embed/${videoId}`
})

const fetchMealDetails = async () => {
  const id = route.params.id
  if (!id) return

  loading.value = true
  error.value = ''

  try {
    const response = await mealService.getMealById(id)
    if (response.data.meals && response.data.meals.length > 0) {
      meal.value = response.data.meals[0]
    } else {
      error.value = 'Meal not found'
    }
  } catch (err) {
    error.value =
      'Failed to load meal details. Please check your internet connection and try again.'
    console.error('Meal details error:', err)
  } finally {
    loading.value = false
  }
}

const getRandomMeal = async () => {
  try {
    const response = await mealService.getRandomMeal()
    if (response.data.meals && response.data.meals.length > 0) {
      const randomMeal = response.data.meals[0]
      router.push(`/meal/${randomMeal.idMeal}`)
    }
  } catch (err) {
    console.error('Random meal error:', err)
  }
}

// Watch for route changes
watch(
  () => route.params.id,
  () => {
    fetchMealDetails()
  }
)

onMounted(() => {
  fetchMealDetails()
})
</script>

<style scoped>
.prose {
  max-width: none;
}
.prose p {
  margin-bottom: 1rem;
}
</style>
