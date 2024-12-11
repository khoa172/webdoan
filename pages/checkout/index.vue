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
              @blur="validatePhone"
            />
          </div>
          <div class="mb-3">
            <label for="customerEmail" class="form-label">Email</label>
            <input
              type="email"
              id="customerEmail"
              v-model="customer.email"
              class="form-control"
              required
              @blur="validateEmail"
            />
          </div>
          <div class="mb-3">
            <label for="province" class="form-label">Tỉnh/Thành phố</label>
            <select
              id="province"
              v-model="selectedProvince"
              @change="fetchDistricts"
              class="form-select"
              required
            >
              <option value="" disabled>Chọn Tỉnh/Thành phố</option>
              <option
                v-for="province in provinces"
                :key="province.code"
                :value="province.code"
              >
                {{ province.name }}
              </option>
            </select>
          </div>
          <div class="mb-3" v-if="districts.length">
            <label for="district" class="form-label">Quận/Huyện</label>
            <select
              id="district"
              v-model="selectedDistrict"
              @change="fetchWards"
              class="form-select"
              required
            >
              <option value="" disabled>Chọn Quận/Huyện</option>
              <option
                v-for="district in districts"
                :key="district.code"
                :value="district.code"
              >
                {{ district.name }}
              </option>
            </select>
          </div>
          <div class="mb-3" v-if="wards.length">
            <label for="ward" class="form-label">Phường/Xã</label>
            <select
              id="ward"
              v-model="selectedWard"
              class="form-select"
              required
            >
              <option value="" disabled>Chọn Phường/Xã</option>
              <option
                v-for="ward in wards"
                :key="ward.code"
                :value="ward.code"
              >
                {{ ward.name }}
              </option>
            </select>
          </div>
          <div class="mb-3">
            <label for="customerAddress" class="form-label">Địa chỉ chi tiết</label>
            <textarea
              id="customerAddress"
              v-model="customer.address"
              class="form-control"
              required
            ></textarea>
          </div>
          <!-- Phương thức thanh toán -->
          <div class="mb-3">
            <label class="form-label">Phương thức thanh toán</label>
            <div>
              <div class="form-check">
                <input
                  type="radio"
                  id="cod"
                  value="COD"
                  v-model="paymentMethod"
                  class="form-check-input"
                  required
                />
                <label for="cod" class="form-check-label">Thanh toán khi nhận hàng (COD)</label>
              </div>
              <div class="form-check">
                <input
                  type="radio"
                  id="direct"
                  value="Direct"
                  v-model="paymentMethod"
                  class="form-check-input"
                  required
                />
                <label for="direct" class="form-check-label">Thanh toán trực tiếp</label>
              </div>
            </div>
          </div>
          <div class="mb-3">
  <label for="customerNote" class="form-label">Ghi chú</label>
  <textarea
    id="customerNote"
    v-model="customer.note"
    class="form-control"
    placeholder="Nhập ghi chú cho đơn hàng (nếu có)"
  ></textarea>
</div>
          <div class="d-flex justify-content-between align-items-center mt-4">
            <strong class="text-primary fs-5">
              Tổng tiền: {{ totalPrice.toLocaleString() }} VND
            </strong>
            <button class="btn btn-success px-5">Xác nhận</button>
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
const provinces = ref([]);
const districts = ref([]);
const wards = ref([]);
const selectedProvince = ref("");
const selectedDistrict = ref("");
const selectedWard = ref("");
const paymentMethod = ref(""); // Lưu phương thức thanh toán

const customer = ref({
  id: null,
  name: "",
  phone: "",
  email: "",
  address: "",
});

const totalPrice = computed(() =>
  selectedItems.value.reduce((total, item) => total + item.price * item.quantity, 0)
);

const validatePhone = () => {
  const phoneRegex = /^[0-9]{10}$/;
  if (!phoneRegex.test(customer.value.phone)) {
    Swal.fire("Lỗi", "Số điện thoại không hợp lệ.", "error");
  }
};

const validateEmail = () => {
  const emailRegex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;
  if (!emailRegex.test(customer.value.email)) {
    Swal.fire("Lỗi", "Email không hợp lệ.", "error");
  }
};

const fetchProvinces = async () => {
  try {
    const response = await fetch("https://provinces.open-api.vn/api/p/");
    provinces.value = await response.json();
  } catch (error) {
    console.error("Lỗi khi lấy danh sách tỉnh/thành phố:", error);
  }
};

const fetchDistricts = async () => {
  try {
    const response = await fetch(
      `https://provinces.open-api.vn/api/p/${selectedProvince.value}?depth=2`
    );
    const data = await response.json();
    districts.value = data.districts || [];
  } catch (error) {
    console.error("Lỗi khi lấy danh sách quận/huyện:", error);
  }
};

const fetchWards = async () => {
  try {
    const response = await fetch(
      `https://provinces.open-api.vn/api/d/${selectedDistrict.value}?depth=2`
    );
    const data = await response.json();
    wards.value = data.wards || [];
  } catch (error) {
    console.error("Lỗi khi lấy danh sách phường/xã:", error);
  }
};

const submitOrder = async () => {
  if (!paymentMethod.value) {
    Swal.fire("Lỗi", "Vui lòng chọn phương thức thanh toán.", "error");
    return;
  }

  const orderData = {
    customer: {
      id: customer.value.id,
      name: customer.value.name,
      phone: customer.value.phone,
      email: customer.value.email,
      address: customer.value.address,
      note: customer.value.note || "",
    },
    items: selectedItems.value.map((item) => ({
      id: item.id,
      price: item.price,
      quantity: item.quantity,
    })),
    totalPrice: totalPrice.value,
    paymentMethod: paymentMethod.value,
    selectedProvince: provinces.value.find((p) => p.code === selectedProvince.value)?.name,
    selectedDistrict: districts.value.find((d) => d.code === selectedDistrict.value)?.name,
    selectedWard: wards.value.find((w) => w.code === selectedWard.value)?.name,
  };

  try {
    const response = await fetch("http://localhost:3001/api/orders", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(orderData),
    });

    if (!response.ok) throw new Error("Lỗi khi gửi đơn hàng");

    const result = await response.json();
    Swal.fire("Thành công", `Đơn hàng của bạn đã được tạo với mã: ${result.orderId}`, "success");
    router.push("/my-orders");
  } catch (error) {
    console.error("Lỗi khi gửi đơn hàng:", error);
    Swal.fire("Lỗi", "Đã xảy ra lỗi khi tạo đơn hàng.", "error");
  }
};


onMounted(async () => {
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
    return;
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
        router.push("/auth");
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

  await fetchProvinces();
});
</script>

<style scoped>
.container {
  max-width: 800px;
  margin: 0 auto;
}
</style>
