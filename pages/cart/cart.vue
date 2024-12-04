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
            <div class="d-flex justify-content-between align-items-center">
              <div class="d-flex">
                <!-- Hiển thị hình ảnh sản phẩm -->
                <img :src="item.image" alt="product image" class="img-thumbnail" width="100" height="100" />
                <div class="ml-3">
                  <h5>{{ item.name }}</h5>
                  <p>{{ item.price }} VND x {{ item.quantity }} = {{ item.price * item.quantity }} VND</p>
                </div>
              </div>
              
                <div class="d-flex">
                    <!-- Div chứa nút tăng giảm -->
                    <div class="d-flex align-items-center">
                        <!-- Nút giảm số lượng -->
                        <button class="btn btn-secondary btn-sm" @click="decreaseQuantity(item.id)">-</button>
                        <!-- Nút tăng số lượng -->
                        <button class="btn btn-secondary btn-sm mx-1" @click="increaseQuantity(item.id)">+</button>
                    </div>
                    <!-- Div chứa nút xóa với khoảng cách -->
                    <div class="ml-3">
                        <button class="btn btn-danger btn-sm" @click="removeFromCart(item.id)">Xóa</button>
                    </div>
               </div>
            </div>
          </div>
        </div>
  
        <!-- Tổng số lượng và tổng giá trị, và nút thanh toán được căn sang bên phải -->
        <div class="mt-3 d-flex justify-content-end">
          <div>
            <h4>Tổng Số Lượng: {{ totalNum }} sản phẩm</h4>
            <h4>Tổng Giá Trị: {{ totalPrice }} VND</h4>
          </div>
        </div>
  
        <div class="mt-3 d-flex justify-content-end">
          <!-- Nút thanh toán -->
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
  
  // Giảm số lượng sản phẩm
  const decreaseQuantity = (productId) => {
    cartStore.decreaseQuantity(productId); // Gọi hành động giảm số lượng
  };
  
  // Tăng số lượng sản phẩm
  const increaseQuantity = (productId) => {
    cartStore.addToCart({ id: productId }); // Gọi hành động thêm sản phẩm vào giỏ hàng để tăng số lượng
  };
  
  // Hàm thanh toán (có thể gửi dữ liệu giỏ hàng lên backend)
  const checkout = async () => {
    try {
      const response = await $fetch("http://localhost:3001/api/checkout", {
        method: "POST",
        body: {
          id_customer: cartStore.id_customer,
          total_num: cartStore.total_num,
          total_price: cartStore.total_price,
          items: cartStore.items,
        },
      });
      console.log("Thanh toán thành công", response);
      cartStore.clearCart(); // Xóa giỏ hàng sau khi thanh toán thành công
    } catch (error) {
      console.error("Lỗi khi thanh toán:", error);
    }
  };
  </script>
  
  <style scoped>
  /* Căn chỉnh các nút trong cùng một dòng */
  .d-flex.align-items-center {
    display: flex;
    align-items: center;
  }
  
  /* Tăng khoảng cách giữa các nút */
  .mx-2 {
    margin-left: 0.5rem;
    margin-right: 0.5rem;
  }
  
  /* Căn chỉnh các thông tin tổng và nút thanh toán sang bên phải */
  .d-flex.justify-content-end {
    justify-content: flex-end;
  }
  </style>