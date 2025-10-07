import { createRouter, createWebHistory } from 'vue-router'
import Home from '../views/Home.vue'
import Categories from '../views/Categories.vue'
import MealDetails from '../views/MealDetails.vue'
import CategoryMeals from '../views/CategoryMeals.vue'

const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home,
  },
  {
    path: '/categories',
    name: 'Categories',
    component: Categories,
  },
  {
    path: '/category/:category',
    name: 'CategoryMeals',
    component: CategoryMeals,
  },
  {
    path: '/meal/:id',
    name: 'MealDetails',
    component: MealDetails,
  },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

export default router
