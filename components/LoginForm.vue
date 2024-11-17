<template>
  <div class="container mt-5">
    <div class="row justify-content-center">
      <div class="col-md-6">
        <div class="card">
          <div class="card-header">Đăng nhập</div>
          <div class="card-body">
            <form @submit.prevent="submitForm">
              <div class="form-group">
                <label for="username">Tên đăng nhập</label>
                <input
                  type="text"
                  v-model="username"
                  class="form-control"
                  id="username"
                  required
                />
              </div>
              <div class="form-group">
                <label for="password">Mật khẩu</label>
                <input
                  type="password"
                  v-model="password"
                  class="form-control"
                  id="password"
                  required
                />
              </div>
              <button type="submit" class="btn btn-primary mt-3">Đăng nhập</button>
              <p v-if="error" class="text-danger mt-3">{{ error }}</p>
            </form>
          </div>
        </div>
      </div>
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
    const { data } = await useFetch('/admin/login', {
      method: 'POST',
      baseURL: useRuntimeConfig().public.apiBase,
      body: {
        username: username.value,
        password: password.value,
      },
    });

    // Lưu token và chuyển hướng
    if (data.value.token) {
      localStorage.setItem('token', data.value.token);
      router.push('/admin');
    } else {
      throw new Error('Token không tồn tại');
    }
  } catch (err) {
    error.value = err.response?._data?.message || 'Đăng nhập thất bại';
  }
};
</script>

<style scoped>
.container {
  margin-top: 100px;
}
</style>
