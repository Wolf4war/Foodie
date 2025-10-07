import { createApp } from 'vue'
import router from './router'
import './style.css'
import App from './App.vue'
import * as Sentry from '@sentry/vue'

// Import Sentry utilities for testing (development only)
if (import.meta.env.MODE === 'development') {
  import('./utils/sentryUtils.js')
}

const app = createApp(App)

// Initialize Sentry for error tracking and performance monitoring
Sentry.init({
  app,
  dsn: 'https://465c66fa1bbcc378558617e468762645@o4507565418217472.ingest.us.sentry.io/4510149811306496',
  integrations: [Sentry.browserTracingIntegration({ router }), Sentry.replayIntegration()],
  // Environment-based configuration
  environment: import.meta.env.MODE || 'development',

  // Tracing - reduce in production
  tracesSampleRate: import.meta.env.MODE === 'production' ? 0.1 : 1.0,

  // Set 'tracePropagationTargets' to control for which URLs distributed tracing should be enabled
  tracePropagationTargets: [
    'localhost',
    /^https:\/\/.*\.amazonaws\.com/, // AWS services
    /^http:\/\/34\.226\.105\.113/, // Your AWS server
    /^https:\/\/www\.themealdb\.com/, // TheMealDB API
  ],

  // Session Replay - reduce sampling in production
  replaysSessionSampleRate: import.meta.env.MODE === 'production' ? 0.1 : 0.5,
  replaysOnErrorSampleRate: 1.0, // Always capture sessions with errors

  // Enable logs
  enableLogs: true,

  // Only send PII in development
  sendDefaultPii: import.meta.env.MODE !== 'production',

  // Release tracking
  release: import.meta.env.VITE_APP_VERSION || '1.0.0',
})

app.use(router)
app.mount('#app')
