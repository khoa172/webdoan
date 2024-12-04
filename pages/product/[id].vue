<template>
    <div class="container mt-5">
      <div v-if="product" class="card">
        <!-- Hình ảnh sản phẩm -->
        <div class="row g-0">
          <div class="col-md-5">
            <img
              :src="`http://localhost:3001/uploads/${product.images[0]}`"
              class="img-fluid rounded-start"
              alt="Product Image"
            />
          </div>
          <div class="col-md-7">
            <div class="card-body">
              <h2 class="card-title">{{ product.name }}</h2>
              <h4 class="card-subtitle mb-2 text-danger">{{ product.price }} VND</h4>
              <p class="card-text text-muted mb-4">{{ product.description }}</p>
              
              <!-- Thông tin chi tiết -->
              <h5 class="fw-bold">Thông số kỹ thuật</h5>
              <ul class="list-group list-group-flush">
                <li class="list-group-item"><strong>Màn Hình:</strong> {{ product.screen }}</li>
                <li class="list-group-item"><strong>RAM:</strong> {{ product.ram }}</li>
                <li class="list-group-item"><strong>CPU:</strong> {{ product.cpu }}</li>
                <li class="list-group-item"><strong>Bộ Nhớ:</strong> {{ product.memory }}</li>
                <li class="list-group-item"><strong>Hệ Điều Hành:</strong> {{ product.operating_system }}</li>
                <li class="list-group-item"><strong>Camera Trước:</strong> {{ product.front_camera }}</li>
                <li class="list-group-item"><strong>Camera Sau:</strong> {{ product.rear_camera }}</li>
              </ul>
              
              <!-- Nút hành động -->
              <div class="mt-4">
                <button class="btn btn-primary btn-lg me-3">Mua Ngay</button>
                <button class="btn btn-outline-secondary btn-lg" 
                @click="addToCart">Thêm Vào Giỏ Hàng</button>
              </div>
            </div>
          </div>
        </div>
      </div>
  
      <!-- Hiển thị thông báo khi đang tải -->
      <div v-else>
        <p>Đang tải thông tin sản phẩm...</p>
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref, onMounted } from "vue";
  import { useRoute } from "vue-router";
  import { useCartStore } from "@/stores/cart"; // Import store giỏ hàng

  const cartStore = useCartStore(); // Khởi tạo store giỏ hàng
  const route = useRoute();
  const product = ref(null);
  
  // Lấy chi tiết sản phẩm từ API
  const fetchProductDetails = async () => {
    try {
      const productId = route.params.id;
      const response = await $fetch(`http://localhost:3001/api/products/${productId}`);
      product.value = {
        ...response,
        images: JSON.parse(response.images || "[]"), // Giải mã danh sách hình ảnh
      };
    } catch (error) {
      console.error("Lỗi khi tải chi tiết sản phẩm:", error);
    }
  };
  
  // Thêm sản phẩm vào giỏ hàng
const addToCart = () => {
  if (product.value) {
    cartStore.addToCart(product.value); // Gọi hành động addToCart trong store
  }
};

  onMounted(fetchProductDetails);
  </script>
  
  <style scoped>
  .card {
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
  }
  
  .card-title {
    font-size: 1.75rem;
  }
  
  .card-subtitle {
    font-size: 1.5rem;
  }
  
  .card img {
    max-height: 300px;
    object-fit: cover;
  }
  </style>
  