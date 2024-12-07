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
                style="max-width: 80px; max-height: 80px;"/>
            </td>
            <td>{{ item.name }}</td>
            <td>{{ item.price.toLocaleString() }} VND</td>
            <td>{{ item.quantity }}</td>
            <td>{{ (item.price * item.quantity).toLocaleString() }} VND</td>
          </tr>
        </tbody>
      </table>
    </div>

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
            :class="{'is-invalid': !customer.name && formSubmitted}"/>
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
            @blur="validatePhone"/>
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
            @blur="validateEmail"/>
          <div v-if="emailError && formSubmitted" class="invalid-feedback">
            Email không hợp lệ.
          </div>
        </div>

        <!-- Chọn Tỉnh, Huyện, Phường/Xã -->
            <div class="mb-3">
              <label for="customerProvince" class="form-label">Tỉnh/Thành phố</label>
              <select
                id="customerProvince"
                v-model="customer.province"
                class="form-select"
                required
                @change="fetchDistricts">
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
                :disabled="!customer.province" 
                @change="fetchWards">
                <option disabled value="">Chọn huyện/quận</option>
                <option v-for="district in districts" :key="district.id" :value="district.id">{{ district.name }}</option>
              </select>
            </div>

            <div class="mb-3">
              <label for="customerWard" class="form-label">Phường/Xã</label>
              <select
                id="customerWard"
                v-model="customer.ward"
                class="form-select"
                required
                :disabled="!customer.district"> <!-- Disable dropdown phường/xã nếu chưa chọn huyện -->
                <option disabled value="">Chọn phường/xã</option>
                <option v-for="ward in wards" :key="ward.id" :value="ward.id">{{ ward.name }}</option>
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
            :class="{'is-invalid': !customer.address && formSubmitted}"></textarea>
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
            class="form-control"></textarea>
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
import { ref, computed, onMounted } from "vue";
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

// Dữ liệu tỉnh và huyện
const provinces = ref([]);
const districts = ref([]);
const wards = ref([]);

// Lấy danh sách tỉnh từ API
const fetchProvinces = async () => {
  try {
    const response = await fetch("https://esgoo.net/api-tinhthanh/4/0.htm");
    const data = await response.json();
    console.log("Dữ liệu tỉnh nhận được:", data); // Kiểm tra cấu trúc dữ liệu

    // Kiểm tra nếu dữ liệu trả về hợp lệ và có mảng trong trường 'data'
    if (data && Array.isArray(data.data)) {
      provinces.value = data.data.map((province) => ({
        id: province.id,    // Lấy ID của tỉnh
        name: province.name // Lấy tên của tỉnh
      }));
    } else {
      console.error("Dữ liệu tỉnh không hợp lệ:", data);
    }
  } catch (error) {
    console.error("Lỗi khi lấy danh sách tỉnh:", error);
  }
};

// Lấy danh sách quận/huyện theo tỉnh
const fetchDistricts = async () => {
  if (customer.value.province) {
    // Reset giá trị quận khi thay đổi tỉnh
    customer.value.district = '';

    try {
      // Lấy dữ liệu quận/huyện từ API với {A} = 2 và {B} = id tỉnh
      const response = await fetch(`https://esgoo.net/api-tinhthanh/2/${customer.value.province}.htm`);
      const data = await response.json();

      console.log("Dữ liệu quận/huyện nhận được:", data); // Kiểm tra dữ liệu quận/huyện

      // Kiểm tra cấu trúc dữ liệu trả về
      if (data && data.error === 0 && Array.isArray(data.data)) {
        // Nếu có dữ liệu quận/huyện hợp lệ
        districts.value = data.data.map((district) => ({
          id: district.id,
          name: district.name
        }));
      } else {
        console.error("Dữ liệu quận/huyện không hợp lệ:", data);
        districts.value = []; // Reset nếu không hợp lệ
      }
    } catch (error) {
      console.error("Lỗi khi lấy danh sách quận/huyện:", error);
      districts.value = []; // Reset nếu có lỗi
    }
  } else {
    // Nếu không có tỉnh, reset danh sách quận/huyện
    districts.value = [];
  }
};

// Lấy danh sách phường/xã theo quận/huyện
const fetchWards = async () => {
  if (customer.value.district) {
    try {
      // Lấy dữ liệu phường/xã từ API với {A} = 3 và {B} = id huyện/quận
      const response = await fetch(`https://esgoo.net/api-tinhthanh/3/${customer.value.district}.htm`);
      const data = await response.json();

      console.log("Dữ liệu phường/xã nhận được:", data); // Kiểm tra dữ liệu phường/xã

      // Kiểm tra cấu trúc dữ liệu trả về
      if (data && data.error === 0 && Array.isArray(data.data)) {
        wards.value = data.data.map((ward) => ({
          id: ward.id,
          name: ward.name
        }));
      } else {
        console.error("Dữ liệu phường/xã không hợp lệ:", data);
        wards.value = []; // Reset nếu không hợp lệ
      }
    } catch (error) {
      console.error("Lỗi khi lấy danh sách phường/xã:", error);
      wards.value = []; // Reset nếu có lỗi
    }
  } else {
    // Nếu không có quận, reset danh sách phường/xã
    wards.value = [];
  }
};

//kiem tra form
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

const formInvalid = computed(() => {
  formSubmitted.value = true;
  validatePhone();
  validateEmail();
  return !customer.value.name || !customer.value.phone || !customer.value.email || !customer.value.province || !customer.value.district || !customer.value.address || phoneError.value || emailError.value;
});

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

onMounted(() => {
  fetchProvinces();
});
</script>

<style scoped>
.container {
  max-width: 800px;
  margin: 0 auto;
}
</style>
