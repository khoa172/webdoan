<template>
  <div class="container mt-5">
    <div class="order-header text-center">
      <h2>Chi Tiết Đơn Hàng</h2>
    </div>
    <div v-if="!order" class="alert alert-warning text-center mt-4">
      <p>Không tìm thấy thông tin đơn hàng.</p>
    </div>
    <div v-else class="order-details mt-4">
      <!-- Thông tin đơn hàng -->
      <div class="order-info mb-4">
        <h3 class="text-primary">Thông Tin Đơn Hàng</h3>
        <p><strong>Mã Đơn Hàng:</strong> {{ order.code }}</p>
        <p><strong>Ngày Tạo:</strong> {{ order.create_date }}</p>
        <p><strong>Trạng Thái:</strong> <span :class="statusClass(order.status)">{{ order.status }}</span></p>
        <p><strong>Ghi Chú:</strong> {{ order.note || 'Không có' }}</p>
      </div>

      <!-- Thông tin khách hàng -->
      <div class="customer-info mb-4">
        <h3 class="text-primary">Thông Tin Khách Hàng</h3>
        <p><strong>Họ và Tên:</strong> {{ order.customer_name }}</p>
        <p><strong>Số Điện Thoại:</strong> {{ order.customer_phone }}</p>
        <p><strong>Email:</strong> {{ order.customer_email }}</p>
        <p><strong>Địa Chỉ:</strong> {{ order.customer_address }}</p>
      </div>

      <!-- Danh sách sản phẩm -->
      <div class="product-list mb-4">
        <h3 class="text-primary">Danh Sách Sản Phẩm</h3>
        <table class="table table-hover">
          <thead class="table-dark">
            <tr>
              <th>Tên Sản Phẩm</th>
              <th>Số Lượng</th>
              <th>Đơn Giá</th>
              <th>Tổng</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="item in order.items" :key="item.id">
              <td>{{ item.name }}</td>
              <td>{{ item.quantity }}</td>
              <td>{{ formatPrice(item.price / item.quantity) }}</td>
              <td>{{ formatPrice(item.price) }}</td>
            </tr>
          </tbody>
          <tfoot>
            <tr>
              <td colspan="3" class="text-end"><strong>Tổng Thanh Toán:</strong></td>
              <td><strong>{{ formatPrice(order.total_price) }}</strong></td>
            </tr>
          </tfoot>
        </table>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import { useRoute } from "vue-router";

const route = useRoute();
const order = ref(null);

const loadOrderDetails = async () => {
  const { id } = route.params;
  try {
    const response = await fetch(`http://localhost:3001/api/orders/details/${id}`);
    if (response.ok) {
      order.value = await response.json();
    } else {
      throw new Error("Không thể tải chi tiết đơn hàng.");
    }
  } catch (error) {
    console.error(error.message);
  }
};

onMounted(() => {
  loadOrderDetails();
});

const formatPrice = (price) => {
  return new Intl.NumberFormat("vi-VN", {
    style: "currency",
    currency: "VND",
  }).format(price);
};

const statusClass = (status) => {
  switch (status) {
    case "Thành công":
      return "text-success";
    case "Chờ xác nhận":
      return "text-warning";
    case "Hủy":
      return "text-danger";
    default:
      return "text-muted";
  }
};
</script>

<style scoped>
.container {
  max-width: 800px;
  margin: 0 auto;
  font-family: "Arial", sans-serif;
}

.order-header h2 {
  font-size: 2rem;
  margin-bottom: 20px;
}

.order-info,
.customer-info,
.product-list {
  padding: 20px;
  border: 1px solid #ddd;
  border-radius: 5px;
  background: #f9f9f9;
}

.table-hover tbody tr:hover {
  background-color: #f1f1f1;
}

.table-dark th {
  background-color: #343a40;
  color: #fff;
}

.text-primary {
  color: #007bff;
}

.text-success {
  color: #28a745;
}

.text-warning {
  color: #ffc107;
}

.text-danger {
  color: #dc3545;
}

.text-muted {
  color: #6c757d;
}
</style>
