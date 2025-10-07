import axios from 'axios'
import * as Sentry from '@sentry/vue'

const BASE_URL = import.meta.env.VITE_API_BASE_URL || 'https://www.themealdb.com/api/json/v1/1'

const api = axios.create({
  baseURL: BASE_URL,
  timeout: 10000, // 10 second timeout
})

// Add request interceptor for logging
api.interceptors.request.use(
  config => {
    // Log API requests in development
    if (import.meta.env.VITE_DEBUG === 'true') {
      console.log(`API Request: ${config.method?.toUpperCase()} ${config.url}`)
    }
    return config
  },
  error => {
    Sentry.captureException(error)
    return Promise.reject(error)
  }
)

// Add response interceptor for error handling
api.interceptors.response.use(
  response => {
    // Log successful responses in development
    if (import.meta.env.VITE_DEBUG === 'true') {
      console.log(`API Response: ${response.status} ${response.config.url}`)
    }
    return response
  },
  error => {
    // Capture API errors in Sentry with context
    Sentry.withScope(scope => {
      scope.setTag('api_error', true)
      scope.setContext('api_request', {
        url: error.config?.url,
        method: error.config?.method,
        baseURL: error.config?.baseURL,
      })
      scope.setContext('api_response', {
        status: error.response?.status,
        statusText: error.response?.statusText,
        data: error.response?.data,
      })
      Sentry.captureException(error)
    })

    // Log errors in development
    if (import.meta.env.VITE_DEBUG === 'true') {
      console.error('API Error:', error.message)
      console.error('Request config:', error.config)
      if (error.response) {
        console.error('Response data:', error.response.data)
        console.error('Response status:', error.response.status)
      }
    }

    return Promise.reject(error)
  }
)

export const mealService = {
  // Search meals by name
  searchMeals: query => api.get(`/search.php?s=${query}`),

  // Get meal details by ID
  getMealById: id => api.get(`/lookup.php?i=${id}`),

  // Get all categories
  getCategories: () => api.get('/categories.php'),

  // Get meals by category
  getMealsByCategory: category => api.get(`/filter.php?c=${category}`),

  // Get random meal
  getRandomMeal: () => api.get('/random.php'),
}
