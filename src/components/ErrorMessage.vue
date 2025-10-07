<template>
  <div class="flex items-center justify-center p-8">
    <div class="text-center max-w-md">
      <div class="mb-4">
        <svg
          class="w-16 h-16 mx-auto text-red-500"
          fill="none"
          stroke="currentColor"
          viewBox="0 0 24 24"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"
          ></path>
        </svg>
      </div>
      <h3 class="text-lg font-semibold text-gray-800 mb-2">Oops! Something went wrong</h3>
      <p class="text-gray-600 mb-4">{{ message }}</p>
      <button
        v-if="showRetry"
        @click="$emit('retry')"
        class="bg-orange-500 hover:bg-orange-600 text-white px-4 py-2 rounded-lg transition-colors duration-200"
      >
        Try Again
      </button>
    </div>
  </div>
</template>

<script setup>
defineEmits(['retry'])
defineProps({
  message: {
    type: String,
    default: 'Unable to load content. Please try again later.',
  },
  showRetry: {
    type: Boolean,
    default: true,
  },
})
</script>
