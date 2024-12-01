<template>
  <div class="container mt-5">
    <div class="card">
      <div class="card-header bg-secondary text-white">
        <h2>Thông Tin Tài Khoản</h2>
      </div>
      <div class="card-body">
        <!-- Hiển thị thông tin -->
        <div v-if="!isEditing">
          <p><strong>Tên Đăng Nhập:</strong> {{ user.username }}</p>
          <p><strong>Họ và Tên:</strong> {{ user.fullname }}</p>
          <p><strong>Email:</strong> {{ user.mail }}</p>
          <p><strong>Số Điện Thoại:</strong> {{ user.phone }}</p>
          <p><strong>Địa Chỉ:</strong> {{ user.address }}</p>
          <button class="btn btn-primary mt-3" @click="toggleEdit">Sửa Thông Tin</button>
        </div>

        <!-- Form chỉnh sửa -->
        <div v-else>
          <form @submit.prevent="updateAccount">
            <div class="mb-3">
              <label for="fullname" class="form-label">Họ và Tên</label>
              <input
                type="text"
                id="fullname"
                v-model="editForm.fullname"
                class="form-control"
                required
              />
            </div>
            <div class="mb-3">
              <label for="mail" class="form-label">Email</label>
              <input
                type="email"
                id="mail"
                v-model="editForm.mail"
                class="form-control"
                required
              />
            </div>
            <div class="mb-3">
              <label for="phone" class="form-label">Số Điện Thoại</label>
              <input
                type="tel"
                id="phone"
                v-model="editForm.phone"
                class="form-control"
                required
              />
            </div>
            <div class="mb-3">
              <label for="address" class="form-label">Địa Chỉ</label>
              <input
                type="text"
                id="address"
                v-model="editForm.address"
                class="form-control"
                required
              />
            </div>
            <div class="mb-3">
              <label for="old_password" class="form-label">Mật Khẩu Cũ</label>
              <input
                type="password"
                id="old_password"
                v-model="editForm.old_password"
                class="form-control"
                placeholder="Nhập mật khẩu cũ để xác nhận"
                required
              />
            </div>
            <div class="mb-3">
              <label for="new_password" class="form-label">Mật Khẩu Mới</label>
              <input
                type="password"
                id="new_password"
                v-model="editForm.new_password"
                class="form-control"
                placeholder="Nhập mật khẩu mới nếu muốn thay đổi"
              />
            </div>
            <button type="submit" class="btn btn-success mt-3">Cập Nhật</button>
            <button type="button" class="btn btn-secondary mt-3" @click="toggleEdit">Hủy</button>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import { useRouter } from "vue-router";
import { useRuntimeConfig } from "#app";
import Swal from "sweetalert2";

const user = ref({});
const editForm = ref({
  fullname: "",
  mail: "",
  phone: "",
  address: "",
  old_password: "",
  new_password: "",
});
const isEditing = ref(false);
const { public: { apiBase } } = useRuntimeConfig();
const router = useRouter();

// Lấy thông tin tài khoản
const fetchUserDetails = async () => {
  try {
    const userData = JSON.parse(localStorage.getItem("user"));
    if (!userData || !userData.id) {
      console.error("User ID không tồn tại trong localStorage.");
      router.push("/auth");
      return;
    }

    const endpoint = `${apiBase}/api/customers/${userData.id}`;
    const response = await $fetch(endpoint);
    user.value = response;
    editForm.value = { ...response, old_password: "", new_password: "" };
  } catch (error) {
    console.error("Lỗi khi lấy thông tin người dùng:", error);
  }
};

// Chuyển đổi giữa hiển thị và chỉnh sửa
const toggleEdit = () => {
  isEditing.value = !isEditing.value;
};

// Cập nhật thông tin tài khoản
const updateAccount = async () => {
  try {
    if (!editForm.value.old_password) {
      Swal.fire("Lỗi", "Vui lòng nhập mật khẩu cũ để xác nhận.", "error");
      return;
    }

    const endpoint = `${apiBase}/api/customers/${user.value.id}`;
    const response = await $fetch(endpoint, {
      method: "PUT",
      body: editForm.value,
    });

    if (response.message === "Mật khẩu cũ không đúng.") {
      Swal.fire("Lỗi", "Mật khẩu cũ không đúng.", "error");
      return;
    }

    Swal.fire("Thành công", "Thông tin tài khoản đã được cập nhật!", "success");
    isEditing.value = false;
    fetchUserDetails(); // Tải lại thông tin mới
  } catch (error) {
    console.error("Lỗi khi cập nhật tài khoản:", error);
    Swal.fire("Lỗi", "Không thể cập nhật tài khoản.", "error");
  }
};

// Lấy thông tin khi trang tải
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
