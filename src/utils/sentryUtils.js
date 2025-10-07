// Sentry testing utilities
import * as Sentry from '@sentry/vue'

/**
 * Test Sentry error tracking
 * This function intentionally throws an error to test Sentry integration
 */
export const testSentryError = () => {
  try {
    // This will throw an error for testing
    throw new Error('Test error for Sentry integration - this is intentional!')
  } catch (error) {
    Sentry.captureException(error)
    console.log('Test error sent to Sentry!')
  }
}

/**
 * Test Sentry performance tracking
 */
export const testSentryPerformance = () => {
  const transaction = Sentry.startTransaction({
    name: 'test_performance',
    op: 'test',
  })

  // Simulate some work
  setTimeout(() => {
    Sentry.addBreadcrumb({
      message: 'Performance test completed',
      category: 'test',
      level: 'info',
    })
    transaction.finish()
    console.log('Performance test sent to Sentry!')
  }, 1000)
}

/**
 * Test custom user feedback
 */
export const testSentryFeedback = (userEmail = 'test@example.com', feedback = 'Test feedback') => {
  Sentry.captureUserFeedback({
    email: userEmail,
    name: 'Test User',
    comments: feedback,
  })
  console.log('User feedback sent to Sentry!')
}

/**
 * Set user context for Sentry
 */
export const setSentryUser = (userId, email, username) => {
  Sentry.setUser({
    id: userId,
    email: email,
    username: username,
  })
  console.log('User context set in Sentry')
}

/**
 * Add custom breadcrumb
 */
export const addSentryBreadcrumb = (message, category = 'custom', level = 'info', data = {}) => {
  Sentry.addBreadcrumb({
    message,
    category,
    level,
    data,
    timestamp: Date.now() / 1000,
  })
}

// Export for development testing
if (import.meta.env.MODE === 'development') {
  window.sentryTest = {
    testError: testSentryError,
    testPerformance: testSentryPerformance,
    testFeedback: testSentryFeedback,
    setUser: setSentryUser,
    addBreadcrumb: addSentryBreadcrumb,
  }
  console.log('🔍 Sentry testing utilities available at window.sentryTest')
}
