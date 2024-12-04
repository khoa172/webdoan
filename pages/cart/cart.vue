<template>
    <div class="container mt-5">
      <h2>Giỏ Hàng</h2>
  
      <!-- Nếu giỏ hàng trống -->
      <div v-if="cartItems.length === 0">
        <p>Giỏ hàng của bạn hiện tại trống.</p>
      </div>
  
      <!-- Nếu giỏ hàng có sản phẩm -->
      <div v-else>
        <div class="list-group">
          <div class="list-group-item" v-for="item in cartItems" :key="item.id">
            <div class="d-flex justify-content-between">
              <div class="d-flex">
                <!-- Hiển thị hình ảnh sản phẩm -->
                <img :src="item.image" alt="product image" class="img-thumbnail" width="100" height="100" />
                <div class="ml-3">
                  <h5>{{ item.name }}</h5>
                  <p>{{ item.price }} VND x {{ item.quantity }} = {{ item.price * item.quantity }} VND</p>
                </div>
              </div>
              <div>
                <button class="btn btn-danger" @click="removeFromCart(item.id)">Xóa</button>
              </div>
            </div>
          </div>
        </div>
  
        <!-- Tổng số lượng và tổng giá trị -->
        <div class="mt-3">
          <h4>Tổng Số Lượng: {{ totalNum }} sản phẩm</h4>
          <h4>Tổng Giá Trị: {{ totalPrice }} VND</h4>
        </div>
  
        <!-- Nút thanh toán hoặc gửi giỏ hàng -->
        <div class="mt-4">
          <button class="btn btn-success" @click="checkout">Thanh Toán</button>
        </div>
      </div>
    </div>
  </template>
  
  <script setup>
  import { useCartStore } from "@/stores/cart"; // Import store giỏ hàng
  
  const cartStore = useCartStore(); // Khởi tạo store giỏ hàng
  
  const cartItems = computed(() => cartStore.items); // Lấy danh sách sản phẩm trong giỏ hàng
  const totalNum = computed(() => cartStore.total_num); // Tổng số lượng sản phẩm
  const totalPrice = computed(() => cartStore.total_price); // Tổng giá trị giỏ hàng
  
  // Xóa sản phẩm khỏi giỏ hàng
  const removeFromCart = (productId) => {
    cartStore.removeFromCart(productId); // Gọi hành động xóa sản phẩm khỏi giỏ hàng
  };
  
  // Hàm thanh toán (có thể gửi dữ liệu giỏ hàng lên backend)
  const checkout = async () => {
    try {
      // Giả sử bạn cần gửi dữ liệu giỏ hàng lên API để thanh toán
      const response = await $fetch("http://localhost:3001/api/checkout", {
        method: "POST",
        body: {
          id_customer: cartStore.id_customer, // Gửi id_customer
          total_num: cartStore.total_num, // Gửi tổng số lượng sản phẩm
          total_price: cartStore.total_price, // Gửi tổng giá trị giỏ hàng
          items: cartStore.items, // Gửi danh sách các sản phẩm trong giỏ
        },
      });
      console.log("Thanh toán thành công", response);
      cartStore.clearCart(); // Xóa giỏ hàng sau khi thanh toán thành công
    } catch (error) {
      console.error("Lỗi khi thanh toán:", error);
    }
  };
  </script>