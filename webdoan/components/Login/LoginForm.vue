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
                  <input type="text" v-model="username" class="form-control" id="username" required>
                </div>
                <div class="form-group">
                  <label for="password">Mật khẩu</label>
                  <input type="password" v-model="password" class="form-control" id="password" required>
                </div>
                <button type="submit" class="btn btn-primary mt-3">Đăng nhập</button>
              </form>
            </div>
          </div>
        </div>
      </div>
    </div>
  </template>
  <script>
  export default {
    data() {
      return {
        username: '',
        password: ''
      };
    },
    methods: {
      submitForm() {
        console.log('Tên đăng nhập:', this.username);
        console.log('Mật khẩu:', this.password);
      }
    }
  };
  </script>
  
  <style scoped>
  .container {
    margin-top: 100px;
  }
  </style>
  