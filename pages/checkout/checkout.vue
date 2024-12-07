<template>
    <div class="container mt-5">
      <h2 class="text-center mb-4">Thông tin thanh toán</h2>
  
      <!-- Thông tin sản phẩm -->
    <div class="product-summary mb-4">
    <h4 class="mb-3">Thông tin sản phẩm</h4>
    <table class="table table-bordered">
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
            <!-- Hiển thị hình ảnh -->
            <td>
            <img
                :src="item.image"
                alt="Product Image"
                style="max-width: 80px; max-height: 80px;"
                class="img-thumbnail"
            />
            </td>
            <!-- Tên sản phẩm -->
            <td>{{ item.name }}</td>
            <!-- Giá -->
            <td>{{ item.price.toLocaleString() }} VND</td>
            <!-- Số lượng -->
            <td>{{ item.quantity }}</td>
            <!-- Tạm tính -->
            <td>{{ (item.price * item.quantity).toLocaleString() }} VND</td>
        </tr>
        </tbody>
    </table>
    </div>
  
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
            />
          </div>
          <div class="mb-3">
            <label for="customerPhone" class="form-label">Số điện thoại</label>
            <input
              type="text"
              id="customerPhone"
              v-model="customer.phone"
              class="form-control"
              required
            />
          </div>
          <div class="mb-3">
            <label for="customerEmail" class="form-label">Email</label>
            <input
              type="email"
              id="customerEmail"
              v-model="customer.email"
              class="form-control"
            />
          </div>
          <div class="mb-3">
            <label for="customerAddress" class="form-label">Địa chỉ</label>
            <textarea
              id="customerAddress"
              v-model="customer.address"
              class="form-control"
              required
            ></textarea>
            <div class="text-end">
                 <strong>Tổng tiền: {{ totalPrice.toLocaleString() }} VND</strong>
            </div>
          </div>
          <button class="btn btn-primary">Xác nhận</button>
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
    selectedItems.value.reduce((total, item) => total + item.price * item.quantity, 0)
  );
  
  // Thông tin khách hàng
  const customer = ref({
    name: "",
    phone: "",
    email: "",
    address: "",
  });
  
  // Gửi đơn hàng
  const submitOrder = async () => {
    try {
      // Tạo đơn hàng
      const order = {
        customer: customer.value,
        items: selectedItems.value,
        totalPrice: totalPrice.value,
      };
  
      // Gọi API lưu vào database
      await $fetch("http://localhost:3001/api/order", {
        method: "POST",
        body: order,
      });
  
      Swal.fire("Thành công!", "Đơn hàng của bạn đã được lưu.", "success");
      cartStore.clearCart();
    } catch (error) {
      Swal.fire("Lỗi!", "Đã xảy ra lỗi khi lưu đơn hàng.", "error");
    }
  };
  </script>
  
  <style scoped>
  .container {
    max-width: 800px;
    margin: 0 auto;
  }
  </style>