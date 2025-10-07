<template>
  <div v-if="hasError" class="min-h-screen flex items-center justify-center bg-gray-50">
    <div class="max-w-md w-full bg-white rounded-lg shadow-lg p-6 text-center">
      <div class="w-16 h-16 mx-auto mb-4 text-red-500">
        <svg fill="currentColor" viewBox="0 0 24 24">
          <path
            d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"
          />
        </svg>
      </div>
      <h2 class="text-xl font-semibold text-gray-800 mb-2">Oops! Something went wrong</h2>
      <p class="text-gray-600 mb-4">
        We're sorry, but something unexpected happened. Our team has been notified.
      </p>
      <div class="space-y-2">
        <button
          @click="retry"
          class="w-full bg-orange-500 text-white px-4 py-2 rounded-lg hover:bg-orange-600 transition-colors"
        >
          Try Again
        </button>
        <button
          @click="reportFeedback"
          class="w-full bg-gray-200 text-gray-700 px-4 py-2 rounded-lg hover:bg-gray-300 transition-colors"
        >
          Report Issue
        </button>
      </div>

      <div v-if="showDetails" class="mt-4 p-3 bg-gray-100 rounded text-left">
        <p class="text-sm font-mono text-gray-600">{{ errorMessage }}</p>
      </div>

      <button @click="toggleDetails" class="mt-2 text-sm text-gray-500 hover:text-gray-700">
        {{ showDetails ? 'Hide' : 'Show' }} Details
      </button>
    </div>
  </div>

  <slot v-else />
</template>

<script setup>
import { ref, onErrorCaptured } from 'vue'
import * as Sentry from '@sentry/vue'

defineProps({
  fallbackComponent: {
    type: Object,
    default: null,
  },
})

const hasError = ref(false)
const errorMessage = ref('')
const showDetails = ref(false)

const retry = () => {
  hasError.value = false
  errorMessage.value = ''
  showDetails.value = false

  // Add breadcrumb for user retry action
  Sentry.addBreadcrumb({
    message: 'User clicked retry after error',
    category: 'ui',
    level: 'info',
  })

  // Force re-render by reloading the page
  window.location.reload()
}

const reportFeedback = () => {
  // You can implement a feedback modal here
  // For now, we'll just capture user feedback intent
  Sentry.addBreadcrumb({
    message: 'User clicked report issue',
    category: 'ui',
    level: 'info',
  })

  // Simple feedback collection
  const feedback = window.prompt('Please describe what you were doing when the error occurred:')
  if (feedback) {
    Sentry.captureUserFeedback({
      email: 'user@example.com', // You can collect this from user input
      name: 'Anonymous User',
      comments: feedback,
    })
    alert('Thank you for your feedback! We will investigate this issue.')
  }
}

const toggleDetails = () => {
  showDetails.value = !showDetails.value
}

// Capture Vue component errors
onErrorCaptured((error, instance, errorInfo) => {
  hasError.value = true
  errorMessage.value = error.message || 'Unknown error occurred'

  // Capture error in Sentry with Vue component context
  Sentry.withScope(scope => {
    scope.setTag('vue_error_boundary', true)
    scope.setContext('component', {
      name: instance?.$options.name || 'Unknown',
      errorInfo,
    })
    Sentry.captureException(error)
  })

  console.error('ErrorBoundary caught an error:', error)

  // Return false to stop the error from propagating
  return false
})
</script>
