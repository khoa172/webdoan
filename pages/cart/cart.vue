<template>
  <div class="container mt-5">
    <h2 class="mb-4 text-center">Giỏ Hàng</h2>

    <!-- Nếu giỏ hàng trống -->
    <div v-if="cartItems.length === 0" class="text-center py-5">
      <p class="fs-5 text-muted">Giỏ hàng của bạn hiện tại trống.</p>
    </div>

    <!-- Nếu giỏ hàng có sản phẩm -->
    <div v-else>
      <div class="cart-list">
        <div
          class="cart-item row align-items-center mb-3 p-3 border rounded"
          v-for="item in cartItems"
          :key="item.id"
          :class="{ 'selected-item': selectedItems.includes(item) }"
        >
          <!-- Cột Checkbox -->
          <div class="col-auto text-center">
            <input
              type="checkbox"
              v-model="selectedItems"
              :value="item"
              class="form-check-input"
            />
          </div>

          <!-- Cột Ảnh sản phẩm và tên (điều hướng đến trang chi tiết sản phẩm) -->
          <div
            class="col-6 d-flex align-items-center product-info"
            @click="goToDetail(item.id)"
            style="cursor: pointer;"
          >
            <img
              :src="item.image"
              alt="product image"
              class="img-fluid rounded shadow-sm me-3"
              style="max-width: 100px; max-height: 100px;"
            />
            <div>
              <h5 class="mb-1 text-primary">{{ item.name }}</h5>
              <p class="text-muted mb-1">Mã SP: {{ item.code }}</p>
              <p class="text-muted mb-0">{{ item.price.toLocaleString() }} VND</p>
            </div>
          </div>

          <!-- Cột Điều chỉnh số lượng -->
          <div class="col-2 text-center">
            <div class="d-flex justify-content-center align-items-center">
              <button
                class="btn btn-outline-secondary btn-sm"
                @click="decreaseQuantity(item.id)"
              >
                -
              </button>
              <span class="mx-3">{{ item.quantity }}</span>
              <button
                class="btn btn-outline-secondary btn-sm"
                @click="increaseQuantity(item.id)"
              >
                +
              </button>
            </div>
          </div>

          <!-- Cột Tổng tiền -->
          <div class="col-2 text-center">
            <strong class="text-success">
              {{ (item.price * item.quantity).toLocaleString() }} VND
            </strong>
          </div>

          <!-- Cột Xóa -->
          <div class="col-auto text-center">
            <button
              class="btn btn-outline-danger btn-sm"
              @click="removeFromCart(item.id)"
            >
              <i class="bi bi-trash"></i>
            </button>
          </div>
        </div>
      </div>

      <!-- Phần Tổng tiền -->
      <div class="cart-summary mt-4 p-3 border rounded bg-light">
        <div class="d-flex justify-content-between align-items-center mb-3">
          <h5 class="mb-0">Tạm tính:</h5>
          <h5 class="mb-0 text-primary">
            {{ selectedTotalPrice.toLocaleString() }} VND
          </h5>
        </div>
        <div class="text-end">
          <button
            class="btn btn-success px-4"
            :disabled="selectedItems.length === 0"
            @click="checkout"
          >
            Mua Ngay
          </button>
        </div>
      </div>
    </div>
  </div>
</template>





  
<script setup>
import { computed, ref, onMounted } from "vue";
import { useRouter } from "vue-router"; // Import router để điều hướng
import { useCartStore } from "@/stores/cart"; // Import store giỏ hàng
import Swal from "sweetalert2"; // Import SweetAlert2

const router = useRouter(); // Khởi tạo router
const cartStore = useCartStore();

const cartItems = computed(() => cartStore.items);
const totalPrice = computed(() => cartStore.total_price);
const selectedItems = ref([]); // Lưu trạng thái sản phẩm được chọn

// Tính tổng giá trị của các sản phẩm đã chọn
const selectedTotalPrice = computed(() =>
  cartItems.value.reduce(
    (total, item) => total + (item.price || 0) * (item.quantity || 0),
    0
  )
);

// Chuyển đến trang chi tiết sản phẩm
const goToDetail = (productId) => {
  router.push(`/product/${productId}`);
};

// Kiểm tra xem người dùng đã đăng nhập chưa
const checkAuthentication = () => {
  const user = localStorage.getItem("user"); // Lấy thông tin người dùng từ localStorage
  if (!user) {
    Swal.fire({
      title: "Yêu cầu đăng nhập",
      text: "Bạn cần đăng nhập để truy cập giỏ hàng.",
      icon: "warning",
      showCancelButton: false,
      confirmButtonText: "OK",
    }).then(() => {
      router.push("/auth"); // Chuyển hướng đến trang đăng nhập
    });
  }
};

const removeFromCart = (productId) => {
  cartStore.removeFromCart(productId);
};

const decreaseQuantity = (productId) => {
  cartStore.decreaseQuantity(productId);
};

const increaseQuantity = (productId) => {
  cartStore.addToCart({ id: productId });
};

const checkout = async () => {
  try {
    const itemsToCheckout = selectedItems.value.map((item) => ({
      id: item.id,
      name: item.name,
      price: item.price,
      quantity: item.quantity,
    }));
    await $fetch("http://localhost:3001/api/checkout", {
      method: "POST",
      body: {
        id_customer: cartStore.id_customer,
        items: itemsToCheckout,
        total_price: selectedTotalPrice.value,
      },
    });
    cartStore.clearCart();
    selectedItems.value = []; // Xóa trạng thái chọn
  } catch (error) {
    console.error("Lỗi khi thanh toán:", error);
  }
};

// Kiểm tra trạng thái đăng nhập khi component được tải
onMounted(() => {
  checkAuthentication();
});
</script>





  
<style scoped>

.cart-item {
  background-color: #fff;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
  transition: transform 0.3s, box-shadow 0.3s;
}

.cart-item:hover {
  transform: translateY(-3px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.cart-item.selected-item {
  background-color: #eaf5ff;
  border-color: #007bff;
}

.product-info:hover h5 {
  color: #0056b3;
}

.cart-summary {
  background-color: #f9f9f9;
  border: 1px solid #ddd;
}

.text-end button {
  font-size: 16px;
}

</style>

