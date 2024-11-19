<template>
  <div class="container mt-5">
    <div class="card">
      <div class="card-header bg-secondary text-white">
        <h2>Thông Tin Tài Khoản</h2>
      </div>
      <div class="card-body">
        <p><strong>Tên Đăng Nhập:</strong> {{ user.username }}</p>
        <p><strong>Họ và Tên:</strong> {{ user.fullname }}</p>
        <p><strong>Email:</strong> {{ user.mail }}</p>
        <p><strong>Số Điện Thoại:</strong> {{ user.phone }}</p>
        <p><strong>Địa Chỉ:</strong> {{ user.address }}</p>
        <p><strong>Ngày Tạo:</strong> {{ user.create_date }}</p>
        <button class="btn btn-primary mt-3" @click="showCustomerTable = true">Sửa Thông Tin</button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { useRuntimeConfig } from '#app';

const user = ref({});
const { public: { apiBase } } = useRuntimeConfig();
const router = useRouter();

const fetchUserDetails = async () => {
  try {
    const userData = JSON.parse(localStorage.getItem('user'));
    if (!userData || !userData.id) {
      console.error('User ID không tồn tại trong localStorage.');
      router.push('/auth'); // Điều hướng đến trang đăng nhập nếu không tìm thấy user ID
      return;
    }

    const endpoint = userData.role === 'admin'
      ? `${apiBase}/api/customers/admin/${userData.id}`
      : `${apiBase}/api/customers/${userData.id}`;

    const response = await $fetch(endpoint);
    user.value = response;
  } catch (error) {
    console.error('Lỗi khi lấy thông tin người dùng:', error);
  }
};

// Xử lý nút "Sửa Thông Tin"
const editAccount = () => {
  if (user.value.role === 'admin') {
    alert('Admin không thể chỉnh sửa thông tin tại giao diện này.');
  } else {
    router.push(`/edit-account/${user.value.id}`);
  }
};

// Lấy thông tin người dùng khi trang được tải
onMounted(() => {
  fetchUserDetails();
});
</script>



<style scoped>
.container {
  max-width: 600px;
}

.card-header {
  text-align: center;
}

.card-body {
  font-size: 16px;
}

.btn {
  display: block;
  width: 100%;
}
</style>
