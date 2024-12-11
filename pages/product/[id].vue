<template>
  <div class="container mt-5">
    <div v-if="product" class="card shadow-lg border-0">
      <!-- Hình ảnh sản phẩm -->
      <div class="row g-0">
        <div class="col-md-6">
          <div class="p-4 text-center">
            <img
              :src="product.images && product.images[0] ? `http://localhost:3001/uploads/${product.images[0]}` : '/path/to/default-image.jpg'"
              class="img-fluid rounded"
              alt="Product Image"
              style="max-height: 400px; object-fit: cover;"
            />
          </div>
        </div>

        <!-- Thông tin sản phẩm -->
        <div class="col-md-6">
          <div class="card-body p-4">
            <h2 class="card-title fw-bold text-primary">{{ product.name }}</h2>
            <h4 class="card-subtitle mb-3 text-danger">
              {{ formatPrice(product.price) }}
            </h4>
            <p class="card-text text-muted mb-4">
              {{ product.description }}
            </p>

            <!-- Thông số kỹ thuật -->
            <h5 class="fw-bold mb-3">Thông số kỹ thuật</h5>
            <ul class="list-group list-group-flush mb-4">
              <li class="list-group-item">
                <strong>Màn Hình:</strong> {{ product.screen }}
              </li>
              <li class="list-group-item">
                <strong>RAM:</strong> {{ product.ram }}
              </li>
              <li class="list-group-item">
                <strong>CPU:</strong> {{ product.cpu }}
              </li>
              <li class="list-group-item">
                <strong>Bộ Nhớ:</strong> {{ product.memory }}
              </li>
              <li class="list-group-item">
                <strong>Hệ Điều Hành:</strong> {{ product.operating_system }}
              </li>
              <li class="list-group-item">
                <strong>Camera Trước:</strong> {{ product.front_camera }}
              </li>
              <li class="list-group-item">
                <strong>Camera Sau:</strong> {{ product.rear_camera }}
              </li>
            </ul>

            <!-- Nút hành động -->
            <div class="d-flex gap-3">
              <button class="btn btn-primary btn-lg flex-fill" @click="buyNow">
                Mua Ngay
              </button>
              <button
                class="btn btn-outline-secondary btn-lg flex-fill"
                @click="addToCart"
              >
                <i class="bi bi-cart-plus"></i> Thêm Vào Giỏ Hàng
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Hiển thị thông báo khi đang tải -->
    <div v-else>
      <div class="text-center mt-5">
        <div class="spinner-border text-primary" role="status">
          <span class="visually-hidden">Loading...</span>
        </div>
        <p class="mt-3">Đang tải thông tin sản phẩm...</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import { useRoute, useRouter } from "vue-router";
import { useCartStore } from "@/stores/cart";
import Swal from "sweetalert2";

const cartStore = useCartStore();
const route = useRoute();
const router = useRouter();
const product = ref(null);

// Lấy chi tiết sản phẩm từ API
const fetchProductDetails = async () => {
  try {
    const productId = route.params.id;
    const response = await $fetch(`http://localhost:3001/api/products/${productId}`);
    product.value = {
      ...response,
      images: response.images ? JSON.parse(response.images) : [], // Xử lý mảng hình ảnh
    };
  } catch (error) {
    console.error("Lỗi khi tải chi tiết sản phẩm:", error);
  }
};

// Mua ngay
const buyNow = () => {
  if (product.value) {
    router.push({
      name: "checkout",
      query: {
        items: JSON.stringify([
          {
            id: product.value.id,
            name: product.value.name,
            price: product.value.price,
            quantity: 1,
            image: product.value.images && product.value.images[0] ? `http://localhost:3001/uploads/${product.value.images[0]}` : "/path/to/default-image.jpg",
          },
        ]),
      },
    });
  }
};

// Thêm vào giỏ hàng
const addToCart = () => {
  if (product.value) {
    cartStore.addToCart(product.value);
    Swal.fire({
      icon: "success",
      title: "Đã thêm vào giỏ hàng!",
      text: `${product.value.name} đã được thêm vào giỏ hàng của bạn.`,
      showConfirmButton: false,
      timer: 2000,
    });
  }
};

// Định dạng giá
const formatPrice = (price) => {
  return new Intl.NumberFormat("vi-VN", {
    style: "currency",
    currency: "VND",
  }).format(price);
};

onMounted(fetchProductDetails);
</script>

<style scoped>
.card {
  border-radius: 10px;
}

.card img {
  border-radius: 10px;
}

.card-title {
  font-size: 1.8rem;
}

.card-subtitle {
  font-size: 1.5rem;
  font-weight: bold;
}

.spinner-border {
  width: 3rem;
  height: 3rem;
}
</style>
