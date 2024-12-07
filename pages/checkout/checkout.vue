<template>
    <div class="container mt-5">
      <h2 class="text-center mb-4">Thông tin thanh toán</h2>
  
      <!-- Thông tin sản phẩm -->
      <div class="product-summary mb-4">
        <h4 class="mb-3">Thông tin sản phẩm</h4>
        <table class="table table-bordered text-center align-middle">
          <thead>
            <tr>
              <th>Hình ảnh</th>
              <th>Tên sản phẩm</th>
              <th>Giá</th>
              <th>Số lượng</th>
              <th>Tạm tính</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="item in selectedItems" :key="item.id">
              <td>
                <img
                  :src="item.image"
                  alt="Product Image"
                  class="img-thumbnail"
                  style="max-width: 80px; max-height: 80px;"
                />
              </td>
              <td>{{ item.name }}</td>
              <td>{{ item.price.toLocaleString() }} VND</td>
              <td>{{ item.quantity }}</td>
              <td>{{ (item.price * item.quantity).toLocaleString() }} VND</td>
            </tr>
          </tbody>
        </table>
      </div>
  
      <!-- Đường ngăn cách -->
      <hr class="my-5" />
  
      <!-- Thông tin khách hàng -->
      <div class="customer-info mb-4">
        <h4 class="mb-3">Thông tin khách hàng</h4>
        <form @submit.prevent="submitOrder">
          <div class="mb-3">
            <label for="customerName" class="form-label">Họ và tên</label>
            <input
              type="text"
              id="customerName"
              v-model="customer.name"
              class="form-control"
              required
              :class="{'is-invalid': !customer.name && formSubmitted}"
            />
            <div v-if="!customer.name && formSubmitted" class="invalid-feedback">
              Vui lòng nhập họ và tên.
            </div>
          </div>
          <div class="mb-3">
            <label for="customerPhone" class="form-label">Số điện thoại</label>
            <input
              type="text"
              id="customerPhone"
              v-model="customer.phone"
              class="form-control"
              required
              :class="{'is-invalid': phoneError && formSubmitted}"
              @blur="validatePhone"
            />
            <div v-if="phoneError && formSubmitted" class="invalid-feedback">
              Số điện thoại phải có 10 chữ số và không chứa chữ cái.
            </div>
          </div>
          <div class="mb-3">
            <label for="customerEmail" class="form-label">Email</label>
            <input
              type="email"
              id="customerEmail"
              v-model="customer.email"
              class="form-control"
              required
              :class="{'is-invalid': emailError && formSubmitted}"
              @blur="validateEmail"
            />
            <div v-if="emailError && formSubmitted" class="invalid-feedback">
              Email không hợp lệ.
            </div>
          </div>
  
          <!-- Chọn Tỉnh, Huyện -->
          <div class="mb-3">
            <label for="customerProvince" class="form-label">Tỉnh/Thành phố</label>
            <select
              id="customerProvince"
              v-model="customer.province"
              class="form-select"
              required
              @change="fetchDistricts"
            >
              <option disabled value="">Chọn tỉnh/thành phố</option>
              <option v-for="province in provinces" :key="province.id" :value="province.id">{{ province.name }}</option>
            </select>
          </div>
          <div class="mb-3">
            <label for="customerDistrict" class="form-label">Huyện/Quận</label>
            <select
              id="customerDistrict"
              v-model="customer.district"
              class="form-select"
              required
            >
              <option disabled value="">Chọn huyện/quận</option>
              <option v-for="district in districts" :key="district.id" :value="district.id">{{ district.name }}</option>
            </select>
          </div>
  
          <!-- Địa chỉ -->
          <div class="mb-3">
            <label for="customerAddress" class="form-label">Địa chỉ chi tiết</label>
            <textarea
              id="customerAddress"
              v-model="customer.address"
              class="form-control"
              required
              :class="{'is-invalid': !customer.address && formSubmitted}"
            ></textarea>
            <div v-if="!customer.address && formSubmitted" class="invalid-feedback">
              Vui lòng nhập địa chỉ chi tiết.
            </div>
          </div>
  
          <!-- Ghi chú -->
          <div class="mb-3">
            <label for="customerNote" class="form-label">Ghi chú</label>
            <textarea
              id="customerNote"
              v-model="customer.note"
              class="form-control"
            ></textarea>
          </div>
  
          <!-- Phần xác nhận -->
          <div class="d-flex justify-content-between align-items-center mt-4">
            <strong class="text-primary fs-5">
              Tổng tiền: {{ totalPrice.toLocaleString() }} VND
            </strong>
            <button class="btn btn-success px-5" :disabled="formInvalid">Xác nhận</button>
          </div>
        </form>
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref, computed } from "vue";
  import { useCartStore } from "@/stores/cart";
  import Swal from "sweetalert2";
  
  const cartStore = useCartStore();
  const selectedItems = computed(() => cartStore.items);
  const totalPrice = computed(() =>
    selectedItems.value.reduce(
      (total, item) => total + item.price * item.quantity,
      0
    )
  );
  
  // Thông tin khách hàng
  const customer = ref({
    name: "",
    phone: "",
    email: "",
    province: "",
    district: "",
    address: "",
    note: "",
  });
  
  //API Tỉnh và Huyện: thêm hàm fetchProvinces để lấy danh sách tỉnh và fetchDistricts để lấy danh sách huyện khi người dùng chọn tỉnh. có thể thay đổi URL API theo backend của mình.
  // Dữ liệu tỉnh và huyện
  const provinces = ref([]);
  const districts = ref([]);
  
  // Lấy danh sách tỉnh từ API
  const fetchProvinces = async () => {
    try {
      const response = await fetch("http://localhost:3001/api/provinces");
      provinces.value = await response.json();
    } catch (error) {
      console.error("Lỗi khi lấy danh sách tỉnh:", error);
    }
  };
  
  // Lấy danh sách huyện theo tỉnh
  const fetchDistricts = async () => {
    if (customer.value.province) {
      try {
        const response = await fetch(
          `http://localhost:3001/api/districts?provinceId=${customer.value.province}`
        );
        districts.value = await response.json();
      } catch (error) {
        console.error("Lỗi khi lấy danh sách huyện:", error);
      }
    }
  };
  
  // Kiểm tra tính hợp lệ của form
  const phoneError = ref(false);
  const emailError = ref(false);
  const formSubmitted = ref(false);
  const validatePhone = () => {
    const phoneRegex = /^[0-9]{10}$/;
    phoneError.value = !phoneRegex.test(customer.value.phone);
  };
  
  const validateEmail = () => {
    const emailRegex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;
    emailError.value = !emailRegex.test(customer.value.email);
  };
  
  // Kiểm tra tính hợp lệ của form
  const formInvalid = computed(() => {
    formSubmitted.value = true;
    validatePhone();
    validateEmail();
    return !customer.value.name || !customer.value.phone || !customer.value.email || !customer.value.province || !customer.value.district || !customer.value.address || phoneError.value || emailError.value;
  });
  
  // Gửi đơn hàng
  const submitOrder = async () => {
    try {
      const order = {
        customer: customer.value,
        items: selectedItems.value,
        totalPrice: totalPrice.value,
      };
  
      await fetch("http://localhost:3001/api/order", {
        method: "POST",
        body: JSON.stringify(order),
        headers: {
          "Content-Type": "application/json",
        },
      });
  
      Swal.fire("Thành công!", "Đơn hàng của bạn đã được lưu.", "success");
      cartStore.clearCart();
    } catch (error) {
      Swal.fire("Lỗi!", "Đã xảy ra lỗi khi lưu đơn hàng.", "error");
    }
  };
  
  // Fetch tỉnh khi trang load
  fetchProvinces();
  </script>
  
  <style scoped>
  .container {
    max-width: 800px;
    margin: 0 auto;
  }
  </style>
  