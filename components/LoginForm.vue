<template>
  <div>
    <form @submit.prevent="submitForm">
      <div class="mb-3">
        <label for="username" class="form-label">Tên đăng nhập</label>
        <input
          type="text"
          v-model="username"
          class="form-control"
          id="username"
          placeholder="Nhập tên đăng nhập"
          required
        />
      </div>
      <div class="mb-3">
        <label for="password" class="form-label">Mật khẩu</label>
        <input
          type="password"
          v-model="password"
          class="form-control"
          id="password"
          placeholder="Nhập mật khẩu"
          required
        />
      </div>
      <button type="submit" class="btn btn-primary w-100 mt-3">Đăng nhập</button>
      <p v-if="error" class="text-danger mt-3 text-center">{{ error }}</p>
    </form>
    <div class="text-center mt-4">
      <p>
        Chưa có tài khoản?
        <a href="#" class="text-primary" @click.prevent="$emit('switchToRegister')">Đăng ký ngay</a>
      </p>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';

const username = ref('');
const password = ref('');
const error = ref('');
const router = useRouter();

const submitForm = async () => {
  try {
    const response = await $fetch('/api/admin/login', {
      method: 'POST',
      baseURL: useRuntimeConfig().public.apiBase,
      body: {
        username: username.value,
        password: password.value,
      },
    });

    if (response.token) {
      // Lưu token và điều hướng
      localStorage.setItem('token', response.token);
      localStorage.setItem('user', JSON.stringify(response.user));
       // Điều hướng dựa trên vai trò
       if (response.user.role === 'admin') {
        router.push('/admin'); // Chuyển đến trang admin
      } else if (response.user.role === 'customer') {
        router.push('/my-account'); // Chuyển đến trang My Account
      }
    } else {
      throw new Error('Token không tồn tại');
    }
  } catch (err) {
    error.value = err.response?._data?.message || 'Đăng nhập thất bại';
  }
};
</script>


