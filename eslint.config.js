import js from '@eslint/js'
import vue from 'eslint-plugin-vue'
import prettier from '@vue/eslint-config-prettier'

export default [
  {
    name: 'app/files-to-lint',
    files: ['**/*.{js,mjs,jsx,vue}'],
  },

  {
    name: 'app/files-to-ignore',
    ignores: ['**/dist/**', '**/dist-ssr/**', '**/coverage/**'],
  },

  js.configs.recommended,
  ...vue.configs['flat/essential'],
  prettier,

  {
    languageOptions: {
      globals: {
        console: 'readonly',
        process: 'readonly',
        window: 'readonly',
        document: 'readonly',
        setTimeout: 'readonly',
        setInterval: 'readonly',
        clearTimeout: 'readonly',
        clearInterval: 'readonly',
      },
    },
    rules: {
      // Vue.js specific rules
      'vue/multi-word-component-names': 'off', // Allow single-word component names like "Home"
      'vue/no-unused-vars': 'error',

      // JavaScript rules
      'no-console': 'warn', // Allow console but warn
      'no-debugger': 'warn',
      'no-unused-vars': 'warn',
      'no-undef': 'error',

      // Code style - disable these as Prettier handles them
      semi: 'off',
      quotes: 'off',
      indent: 'off',
    },
  },
]
