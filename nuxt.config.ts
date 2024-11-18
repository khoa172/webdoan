export default defineNuxtConfig({
  compatibilityDate: '2024-11-17',
  css: [
    'bootstrap/dist/css/bootstrap.min.css', // Import Bootstrap CSS
  ],

  runtimeConfig: {
    public: {
      apiBase: 'http://localhost:3001', // URL của API Express
    },
  },
    modules: ['@pinia/nuxt'],

});