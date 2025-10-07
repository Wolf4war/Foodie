<template>
  <div class="min-h-screen bg-gray-50">
    <!-- Header -->
    <div class="bg-white shadow-sm py-8">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex items-center mb-4">
          <button
            @click="$router.back()"
            class="mr-4 p-2 rounded-full hover:bg-gray-100 transition-colors duration-200"
          >
            <svg
              class="w-6 h-6 text-gray-600"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M15 19l-7-7 7-7"
              ></path>
            </svg>
          </button>
          <div>
            <h1 class="text-3xl font-bold text-gray-900">{{ $route.params.category }}</h1>
            <p class="mt-2 text-gray-600">Meals in this category</p>
          </div>
        </div>
      </div>
    </div>

    <!-- Content -->
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
      <!-- Loading State -->
      <LoadingSpinner v-if="loading" message="Loading meals..." />

      <!-- Error State -->
      <ErrorMessage v-else-if="error" :message="error" @retry="fetchCategoryMeals" />

      <!-- No Results -->
      <div v-else-if="meals.length === 0" class="text-center py-16">
        <svg
          class="w-24 h-24 mx-auto text-gray-400 mb-4"
          fill="none"
          stroke="currentColor"
          viewBox="0 0 24 24"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"
          ></path>
        </svg>
        <h3 class="text-xl font-semibold text-gray-600 mb-2">No meals found</h3>
        <p class="text-gray-500">This category appears to be empty</p>
      </div>

      <!-- Results -->
      <div v-else>
        <div class="mb-6">
          <p class="text-gray-600">{{ meals.length }} meals found</p>
        </div>
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
          <MealCard v-for="meal in meals" :key="meal.idMeal" :meal="meal" />
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue'
import { useRoute } from 'vue-router'
import { mealService } from '../services/api'
import MealCard from '../components/MealCard.vue'
import LoadingSpinner from '../components/LoadingSpinner.vue'
import ErrorMessage from '../components/ErrorMessage.vue'

const route = useRoute()
const loading = ref(false)
const error = ref('')
const meals = ref([])

const fetchCategoryMeals = async () => {
  const category = route.params.category
  if (!category) return

  loading.value = true
  error.value = ''

  try {
    const response = await mealService.getMealsByCategory(category)
    meals.value = response.data.meals || []
  } catch (err) {
    error.value = 'Failed to load meals. Please check your internet connection and try again.'
    console.error('Category meals error:', err)
  } finally {
    loading.value = false
  }
}

// Watch for route changes
watch(
  () => route.params.category,
  () => {
    fetchCategoryMeals()
  }
)

onMounted(() => {
  fetchCategoryMeals()
})
</script>
