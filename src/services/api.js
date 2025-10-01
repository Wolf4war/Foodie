import axios from 'axios'

const BASE_URL = 'https://www.themealdb.com/api/json/v1/1'

const api = axios.create({
  baseURL: BASE_URL
})

export const mealService = {
  // Search meals by name
  searchMeals: (query) => api.get(`/search.php?s=${query}`),
  
  // Get meal details by ID
  getMealById: (id) => api.get(`/lookup.php?i=${id}`),
  
  // Get all categories
  getCategories: () => api.get('/categories.php'),
  
  // Get meals by category
  getMealsByCategory: (category) => api.get(`/filter.php?c=${category}`),
  
  // Get random meal
  getRandomMeal: () => api.get('/random.php')
}