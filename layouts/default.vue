<template>
    <div class="layout-container">
      <!-- Header -->
      <defaultHeader />
      
      <!-- Nội dung chính -->
      <div class="content-container">
        <NuxtPage />
      </div>
  
      <!-- Footer -->
      <defaultFooter />
    </div>
  </template>
  
  <script>
  import defaultHeader from "~/components/Header/defaultHeader.vue";
  import defaultFooter from "~/components/Footer/defaultFooter.vue";
  
  export default {
    components: {
      defaultHeader,
      defaultFooter,
    },
  };
  </script>
  
  <style scoped>
  .layout-container {
    display: flex;
    flex-direction: column;
    min-height: 100vh; /* Chiều cao tối thiểu toàn màn hình */
  }
  
  .content-container {
    flex-grow: 1; /* Đẩy footer xuống cuối nếu nội dung không đủ */
    padding: 20px;
  }
  </style>
  