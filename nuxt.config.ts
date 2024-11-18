export default defineNuxtConfig({
  compatibilityDate: '2024-11-17',
  css: [
    'bootstrap/dist/css/bootstrap.min.css', 
  ],

  runtimeConfig: {
    public: {
      apiBase: 'http://localhost:3001', 
    },
  },
    modules: ['@pinia/nuxt'],

});