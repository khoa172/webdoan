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
        <div class="mb-3">
          <label for="fullname" class="form-label">Họ và tên</label>
          <input
            type="text"
            v-model="fullname"
            class="form-control"
            id="fullname"
            placeholder="Nhập họ và tên"
            required
          />
        </div>
        <div class="mb-3">
          <label for="email" class="form-label">Email</label>
          <input
            type="email"
            v-model="email"
            class="form-control"
            id="email"
            placeholder="Nhập email"
            required
          />
        </div>
        <div class="mb-3">
          <label for="phone" class="form-label">Số điện thoại</label>
          <input
            type="tel"
            v-model="phone"
            class="form-control"
            id="phone"
            placeholder="Nhập số điện thoại"
            required
          />
        </div>
        <div class="mb-3">
          <label for="address" class="form-label">Địa chỉ</label>
          <textarea
            v-model="address"
            class="form-control"
            id="address"
            rows="3"
            placeholder="Nhập địa chỉ"
            required
          ></textarea>
        </div>
        <button type="submit" class="btn btn-success w-100 mt-3">Đăng ký</button>
        <p v-if="success" class="text-success mt-3 text-center">{{ success }}</p>
        <p v-if="error" class="text-danger mt-3 text-center">{{ error }}</p>
      </form>
      <div class="text-center mt-4">
        <p>
          Đã có tài khoản?
          <a href="#" class="text-primary" @click.prevent="$emit('switchToLogin')">Đăng nhập ngay</a>
        </p>
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref} from 'vue';
  
  const username = ref('');
  const password = ref('');
  const fullname = ref('');
  const email = ref('');
  const phone = ref('');
  const address = ref('');
  const success = ref('');
  const error = ref('');
  const emit = defineEmits(['switchToLogin']);
  
  const submitForm = async () => {
    try {
      const response = await $fetch('/api/customersregister/register', {
        method: 'POST',
        baseURL: useRuntimeConfig().public.apiBase,
        body: {
          username: username.value,
          password: password.value,
          fullname: fullname.value,
          mail: email.value,
          phone: phone.value,
          address: address.value,
        },
      });
  
      if (response.message) {
        success.value = 'Tạo tài khoản thành công!';
      }
    } catch (err) {
      error.value = err.response?._data?.message || 'Đăng ký thất bại';
    }
  };
  </script>
  <style scoped>
  .container {
    margin-top: 100px;
  }
  .text-primary {
    text-decoration: none;
  }
  .text-primary:hover {
    text-decoration: underline;
  }
  </style>
  