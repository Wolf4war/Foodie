<template>
  <div class="min-h-screen bg-gray-50">
    <!-- Header -->
    <div class="bg-white shadow-sm py-8">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <h1 class="text-3xl font-bold text-gray-900">Meal Categories</h1>
        <p class="mt-2 text-gray-600">Explore meals by category</p>
      </div>
    </div>

    <!-- Content -->
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
      <!-- Loading State -->
      <LoadingSpinner v-if="loading" message="Loading categories..." />
      
      <!-- Error State -->
      <ErrorMessage 
        v-else-if="error" 
        :message="error" 
        @retry="fetchCategories"
      />
      
      <!-- Categories Grid -->
      <div v-else class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
        <div
          v-for="category in categories"
          :key="category.idCategory"
          @click="$router.push(`/category/${category.strCategory}`)"
          class="bg-white rounded-xl shadow-lg hover:shadow-xl transition-all duration-300 cursor-pointer transform hover:scale-105 overflow-hidden"
        >
          <div class="relative overflow-hidden">
            <img
              :src="category.strCategoryThumb"
              :alt="category.strCategory"
              class="w-full h-48 object-cover transition-transform duration-300 hover:scale-110"
              loading="lazy"
            />
            <div class="absolute inset-0 bg-gradient-to-t from-black/50 to-transparent"></div>
            <div class="absolute bottom-4 left-4 right-4">
              <h3 class="text-xl font-bold text-white mb-1">
                {{ category.strCategory }}
              </h3>
            </div>
          </div>
          
          <div class="p-4">
            <p class="text-sm text-gray-600 line-clamp-3">
              {{ category.strCategoryDescription }}
            </p>
            <div class="mt-3 flex items-center text-orange-500">
              <span class="text-sm font-medium">Explore recipes</span>
              <svg class="w-4 h-4 ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
              </svg>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { mealService } from '../services/api'
import LoadingSpinner from '../components/LoadingSpinner.vue'
import ErrorMessage from '../components/ErrorMessage.vue'

const loading = ref(false)
const error = ref('')
const categories = ref([])

const fetchCategories = async () => {
  loading.value = true
  error.value = ''
  
  try {
    const response = await mealService.getCategories()
    categories.value = response.data.categories || []
  } catch (err) {
    error.value = 'Failed to load categories. Please check your internet connection and try again.'
    console.error('Categories error:', err)
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchCategories()
})
</script>

<style scoped>
.line-clamp-3 {
  display: -webkit-box;
  -webkit-line-clamp: 3;
  line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
</style>