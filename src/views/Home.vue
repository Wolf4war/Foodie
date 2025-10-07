<template>
  <div class="min-h-screen bg-gray-50">
    <!-- Hero Section -->
    <div class="bg-gradient-to-r from-orange-500 to-red-500 py-16">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
        <h1 class="text-4xl md:text-6xl font-bold text-white mb-4">Welcome to Foodie</h1>
        <p class="text-xl text-orange-100 mb-8 max-w-2xl mx-auto">
          Your ultimate destination for discovering amazing recipes from around the world
        </p>
        <SearchBar @search="handleSearch" />
      </div>
    </div>

    <!-- Content Section -->
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
      <!-- Loading State -->
      <LoadingSpinner v-if="loading" message="Searching for meals..." />

      <!-- Error State -->
      <ErrorMessage v-else-if="error" :message="error" @retry="searchMeals(lastQuery)" />

      <!-- No Results -->
      <div v-else-if="searched && meals.length === 0" class="text-center py-16">
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
            d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"
          ></path>
        </svg>
        <h3 class="text-xl font-semibold text-gray-600 mb-2">No meals found</h3>
        <p class="text-gray-500">
          Try searching for something else like "chicken", "pasta", or "cake"
        </p>
      </div>

      <!-- Results -->
      <div v-else-if="meals.length > 0">
        <h2 class="text-2xl font-bold text-gray-800 mb-8">
          Search Results ({{ meals.length }} found)
        </h2>
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
          <MealCard v-for="meal in meals" :key="meal.idMeal" :meal="meal" />
        </div>
      </div>

      <!-- Welcome State -->
      <div v-else class="text-center py-16">
        <svg class="w-24 h-24 mx-auto text-orange-500 mb-4" fill="currentColor" viewBox="0 0 24 24">
          <path
            d="M18.06 23h1.66c.84 0 1.53-.64 1.63-1.46L23 5.05h-5V1h-1c-1.1 0-2 .9-2 2v2H5V3c0-1.1-.9-2-2-2H2v4.05H0l1.65 16.49c.1.82.79 1.46 1.63 1.46h1.66l1.06-10.61h10l1.06 10.61z"
          />
        </svg>
        <h3 class="text-2xl font-semibold text-gray-800 mb-2">Welcome to Foodie</h3>
        <p class="text-gray-600 mb-8">Start by searching for your favorite meals above</p>

        <!-- Quick suggestions -->
        <div class="max-w-md mx-auto">
          <p class="text-sm text-gray-500 mb-4">Try searching for:</p>
          <div class="flex flex-wrap gap-2 justify-center">
            <button
              v-for="suggestion in suggestions"
              :key="suggestion"
              @click="handleSearch(suggestion)"
              class="bg-white border border-gray-300 rounded-full px-4 py-2 text-sm text-gray-700 hover:bg-orange-50 hover:border-orange-300 transition-colors duration-200"
            >
              {{ suggestion }}
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import SearchBar from '../components/SearchBar.vue'
import MealCard from '../components/MealCard.vue'
import LoadingSpinner from '../components/LoadingSpinner.vue'
import ErrorMessage from '../components/ErrorMessage.vue'
import mealService from '../services/api.js'

const loading = ref(false)
const error = ref('')
const meals = ref([])
const searched = ref(false)
const lastQuery = ref('')

const suggestions = ['chicken', 'pasta', 'cake', 'beef', 'fish', 'vegetarian']

const searchMeals = async query => {
  if (!query.trim()) return

  loading.value = true
  error.value = ''
  lastQuery.value = query

  try {
    const response = await mealService.searchMeals(query)
    meals.value = response.data.meals || []
    searched.value = true
  } catch (err) {
    error.value = 'Failed to search meals. Please check your internet connection and try again.'
  } finally {
    loading.value = false
  }
}

const handleSearch = query => {
  searchMeals(query)
}
</script>
