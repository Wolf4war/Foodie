<template>
  <div class="w-full max-w-md mx-auto">
    <div class="relative">
      <input
        v-model="query"
        @keyup.enter="handleSearch"
        type="text"
        placeholder="Search for meals..."
        class="w-full px-4 py-3 pl-12 pr-4 text-gray-700 bg-white border border-gray-300 rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-orange-500 focus:border-transparent"
      />
      <div class="absolute inset-y-0 left-0 flex items-center pl-3">
        <svg class="w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m21 21-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path>
        </svg>
      </div>
      <button
        @click="handleSearch"
        :disabled="!query.trim()"
        class="absolute inset-y-0 right-0 flex items-center pr-3"
      >
        <svg class="w-5 h-5 text-orange-500 hover:text-orange-600 disabled:text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7l5 5m0 0l-5 5m5-5H6"></path>
        </svg>
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref, defineEmits } from 'vue'

const emit = defineEmits(['search'])
const query = ref('')

const handleSearch = () => {
  if (query.value.trim()) {
    emit('search', query.value.trim())
  }
}
</script>