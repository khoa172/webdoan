<template>
    <div class="container mt-5">
      <h1>{{ isEdit ? 'Sửa Thông Tin Khách Hàng' : 'Thêm Khách Hàng Mới' }}</h1>
      <form @submit.prevent="handleSubmit">
        <div class="mb-3">
          <label for="fullname" class="form-label">Họ Tên</label>
          <input type="text" v-model="form.fullname" class="form-control" id="fullname" required />
        </div>
        <div class="mb-3">
          <label for="mail" class="form-label">Email</label>
          <input type="email" v-model="form.mail" class="form-control" id="mail" required />
        </div>
        <div class="mb-3">
          <label for="phone" class="form-label">Số Điện Thoại</label>
          <input type="tel" v-model="form.phone" class="form-control" id="phone" required />
        </div>
        <div class="mb-3">
          <label for="address" class="form-label">Địa Chỉ</label>
          <textarea v-model="form.address" class="form-control" id="address" rows="3" required></textarea>
        </div>
        <button type="submit" class="btn btn-success">{{ isEdit ? "Cập Nhật" : "Thêm" }}</button>
        <button class="btn btn-secondary" @click="goBack">Hủy</button>
      </form>
    </div>
  </template>
  
  <script setup>
  import { ref } from 'vue';
  import { useRouter, useRoute } from 'vue-router';
  
  const router = useRouter();
  const route = useRoute();
  const isEdit = ref(false);
  const form = ref({
    id: null,
    fullname: '',
    mail: '',
    phone: '',
    address: '',
  });
  
  // Xác định xem là sửa hay thêm
  onMounted(() => {
    if (route.query.id) {
      isEdit.value = true;
      form.value = JSON.parse(decodeURIComponent(route.query.customer));
    }
  });
  
  // Submit form
  const handleSubmit = async () => {
    const { public: { apiBase } } = useRuntimeConfig();
    try {
      if (isEdit.value) {
        await $fetch(`${apiBase}/api/customers/${form.value.id}`, {
          method: 'PUT',
          body: { ...form.value },
        });
      } else {
        await $fetch(`${apiBase}/api/customers`, {
          method: 'POST',
          body: { ...form.value },
        });
      }
      router.push('/admin'); // Quay lại trang admin sau khi hoàn tất
    } catch (error) {
      console.error('Lỗi khi xử lý form khách hàng:', error);
    }
  };
  
  // Hủy và quay lại
  const goBack = () => {
    router.push('/admin');
  };
  </script>
  
