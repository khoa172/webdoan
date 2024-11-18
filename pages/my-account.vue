<template>
    <div>
      <h1>My Account</h1>
      <p>Chào mừng {{ user.fullname }}!</p>
    </div>
  </template>
  
  <script setup>
  import { ref, onMounted } from 'vue';
  
  // Lấy thông tin người dùng từ localStorage
  const user = ref({});
  onMounted(() => {
    const userData = localStorage.getItem('user');
    if (userData) {
      user.value = JSON.parse(userData);
    }
  });
  </script>
  