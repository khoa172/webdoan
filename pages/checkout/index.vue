<template>
  <div class="container mt-5">
    <h2 class="text-center mb-4">Thông tin thanh toán</h2>

    <!-- Thông báo yêu cầu đăng nhập -->
    <div v-if="!customer.id" class="alert alert-warning">
      Bạn cần <a href="/login" class="alert-link">đăng nhập</a> trước khi đặt hàng.
    </div>

    <div v-else>
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
            <button class="btn btn-success px-5" :disabled="formInvalid">
              Xác nhận
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from "vue";
import { useRoute, useRouter } from "vue-router";
import Swal from "sweetalert2";

const route = useRoute();
const router = useRouter();
const selectedItems = ref([]);

// Thông tin khách hàng
const customer = ref({
  id: null, // Thêm id nếu khách đã đăng nhập
  name: "",
  phone: "",
  email: "",
  address: "",
  note: "",
});

// Tính tổng tiền từ các sản phẩm được chọn
const totalPrice = computed(() =>
  selectedItems.value.reduce(
    (total, item) => total + item.price * item.quantity,
    0
  )
);

// Kiểm tra dữ liệu khi form được gửi
const formSubmitted = ref(false);
const phoneError = ref(false);
const emailError = ref(false);

const validatePhone = () => {
  const phoneRegex = /^[0-9]{10}$/;
  phoneError.value = !phoneRegex.test(customer.value.phone);
};

const validateEmail = () => {
  const emailRegex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;
  emailError.value = !emailRegex.test(customer.value.email);
};

const formInvalid = computed(() => {
  formSubmitted.value = true;
  validatePhone();
  validateEmail();
  return (
    !customer.value.name ||
    !customer.value.phone ||
    !customer.value.email ||
    !customer.value.address ||
    phoneError.value ||
    emailError.value
  );
});

// Gửi đơn hàng
const submitOrder = async () => {
  try {
    if (!customer.value.id) {
      Swal.fire("Lỗi!", "Bạn cần đăng nhập trước khi đặt hàng.", "error");
      return;
    }

    const order = {
      customer: {
        id: customer.value.id,
        name: customer.value.name,
        phone: customer.value.phone,
        email: customer.value.email,
        address: customer.value.address,
        note: customer.value.note,
      },
      items: selectedItems.value.map((item) => ({
        id: item.id,
        price: item.price,
        quantity: item.quantity,
      })),
      totalPrice: totalPrice.value,
    };

    const response = await fetch("http://localhost:3001/api/orders", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(order),
    });

    if (!response.ok) {
      throw new Error("Lỗi khi gửi đơn hàng");
    }

    const data = await response.json();

    localStorage.removeItem("cart"); // Xóa giỏ hàng từ localStorage
    selectedItems.value = []; // Xóa dữ liệu giỏ hàng trong component

    Swal.fire("Thành công!", `Đơn hàng đã được lưu với mã: ${data.orderId}`, "success");
    router.push("/my-orders"); // Điều hướng tới trang danh sách đơn hàng
  } catch (error) {
    console.error("Lỗi khi gửi đơn hàng:", error);
    Swal.fire("Lỗi!", "Đã xảy ra lỗi khi lưu đơn hàng.", "error");
  }
};

// Lấy dữ liệu từ query và thông tin người dùng
onMounted(() => {
  const userId = localStorage.getItem("userId");
  const token = localStorage.getItem("token");
  if (!token) {
    Swal.fire({
      title: "Bạn chưa đăng nhập",
      text: "Hãy đăng nhập để tiếp tục.",
      icon: "info",
      confirmButtonText: "Đăng nhập",
    }).then(() => {
      router.push("/auth");
    });
  }
  if (!userId) {
    Swal.fire({
      title: "Yêu cầu đăng nhập",
      text: "Bạn cần đăng nhập để tiếp tục thanh toán.",
      icon: "warning",
      showCancelButton: true,
      confirmButtonText: "Đăng nhập",
      cancelButtonText: "Hủy",
    }).then((result) => {
      if (result.isConfirmed) {
        router.push("/login");
      } else {
        router.push("/cart");
      }
    });
    return;
  }

  customer.value.id = parseInt(userId, 10);

  const itemsQuery = route.query.items;
  if (itemsQuery) {
    try {
      selectedItems.value = JSON.parse(itemsQuery);
    } catch (error) {
      console.error("Lỗi khi giải mã dữ liệu sản phẩm:", error);
    }
  }
});
</script>

<style scoped>
.container {
  max-width: 800px;
  margin: 0 auto;
}
</style>
