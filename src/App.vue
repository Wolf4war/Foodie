<script setup>
import AppNavigation from './components/AppNavigation.vue'
</script>

<template>
  <div id="app" class="min-h-screen bg-gray-50">
    <AppNavigation />
    <main>
      <router-view />
    </main>
  </div>
</template>

<style>
html,
body {
  margin: 0;
  padding: 0;
  font-family:
    'Inter',
    -apple-system,
    BlinkMacSystemFont,
    'Segoe UI',
    Roboto,
    sans-serif;
}

#app {
  min-height: 100vh;
}
</style>
