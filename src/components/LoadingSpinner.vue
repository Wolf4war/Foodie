<template>
  <div class="flex items-center justify-center p-8">
    <div class="relative">
      <div class="w-12 h-12 border-4 border-orange-200 border-t-orange-500 rounded-full animate-spin"></div>
      <div class="mt-4 text-center text-gray-600">
        {{ message }}
      </div>
    </div>
  </div>
</template>

<script setup>
defineProps({
  message: {
    type: String,
    default: 'Loading...'
  }
})
</script>