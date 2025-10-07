<template>
  <div
    @click="$router.push(`/meal/${meal.idMeal}`)"
    class="bg-white rounded-xl shadow-lg hover:shadow-xl transition-all duration-300 cursor-pointer transform hover:scale-105 overflow-hidden"
  >
    <div class="relative overflow-hidden">
      <img
        :src="meal.strMealThumb"
        :alt="meal.strMeal"
        class="w-full h-48 sm:h-56 object-cover transition-transform duration-300 hover:scale-110"
        loading="lazy"
      />
      <div class="absolute top-2 right-2">
        <span class="bg-orange-500 text-white px-2 py-1 rounded-full text-xs font-semibold">
          {{ meal.strCategory }}
        </span>
      </div>
    </div>

    <div class="p-4">
      <h3 class="text-lg font-semibold text-gray-800 mb-2 line-clamp-2">
        {{ meal.strMeal }}
      </h3>

      <div class="flex items-center justify-between">
        <span class="text-sm text-gray-500">
          {{ meal.strArea || 'International' }}
        </span>
        <svg class="w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M9 5l7 7-7 7"
          ></path>
        </svg>
      </div>
    </div>
  </div>
</template>

<script setup>
defineProps({
  meal: {
    type: Object,
    required: true,
  },
})
</script>

<style scoped>
.line-clamp-2 {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
</style>
