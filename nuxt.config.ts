export default defineNuxtConfig({
  compatibilityDate: '2024-11-17',
  css: [
    'bootstrap/dist/css/bootstrap.min.css', // Import Bootstrap CSS
  ],

  runtimeConfig: {
    public: {
      apiBase: 'http://localhost:3001/api', // URL của API Express
    },
  },

});