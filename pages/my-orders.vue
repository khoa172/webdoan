<template>
  <div class="container mt-5">
    <div class="card shadow-sm">
      <div class="card-header text-center">
        <h2 class="mb-0">Đơn Hàng Của Tôi</h2>
      </div>
      <div class="card-body">
        <!-- Hiển thị spinner khi đang tải -->
        <div v-if="isLoading" class="d-flex justify-content-center my-4">
          <div class="spinner-border text-primary" role="status">
            <span class="visually-hidden">Đang tải...</span>
          </div>
        </div>
        
        <!-- Không có đơn hàng -->
        <div v-else-if="orders.length === 0" class="text-center text-muted">
          <p>Bạn chưa có đơn hàng nào.</p>
          <NuxtLink to="/" class="btn btn-outline-primary btn-sm">Tiếp tục mua sắm</NuxtLink>
        </div>
        
        <!-- Danh sách đơn hàng -->
        <div v-else>
          <table class="table table-bordered table-hover table-striped align-middle">
            <thead class="table-dark">
              <tr>
                <th style="width: 20%;">Mã Đơn Hàng</th>
                <th style="width: 20%;">Ngày Tạo</th>
                <th style="width: 20%;">Tổng Tiền</th>
                <th style="width: 20%;">Trạng Thái</th>
                <th style="width: 20%; text-align: center;">Hành Động</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="order in orders" :key="order.id">
                <td>{{ order.code }}</td>
                <td>{{ formatDate(order.create_date) }}</td>
                <td>{{ formatPrice(order.total_price) }}</td>
                <td>
                  <span :class="['badge', getStatusClass(order.status)]">{{ order.status }}</span>
                </td>
                <td class="text-center">
                  <NuxtLink :to="`/order/${order.id}`" class="btn btn-primary btn-sm">
                    Xem Chi Tiết
                  </NuxtLink>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
      <div class="card-footer text-center">
        <NuxtLink to="/" class="btn btn-outline-secondary btn-sm">Quay về Trang Chủ</NuxtLink>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';

const orders = ref([]);
const isLoading = ref(true);
const router = useRouter();

const loadOrders = async () => {
  const userId = localStorage.getItem('userId'); 
  if (!userId) {
    // Nếu chưa đăng nhập, chuyển hướng tới trang đăng nhập
    router.push('/auth');
    return;
  }

  try {
    const response = await fetch(`http://localhost:3001/api/orders/user/${userId}`);
    if (response.ok) {
      orders.value = await response.json();
    } else if (response.status === 404) {
      orders.value = [];
    } else {
      throw new Error('Không thể tải danh sách đơn hàng');
    }
  } catch (error) {
    console.error('Lỗi:', error.message);
  } finally {
    isLoading.value = false;
  }
};

onMounted(() => {
  loadOrders();
});

const formatPrice = (price) => {
  return new Intl.NumberFormat('vi-VN', {
    style: 'currency',
    currency: 'VND',
  }).format(price);
};

const formatDate = (dateStr) => {
  // Giả sử create_date là chuỗi datetime: "2024-12-10 18:02:15"
  // Chúng ta có thể parse và định dạng lại:
  const date = new Date(dateStr.replace(' ', 'T'));
  return date.toLocaleString('vi-VN', { 
    year: 'numeric', 
    month: '2-digit', 
    day: '2-digit', 
    hour: '2-digit', 
    minute: '2-digit'
  });
};

const getStatusClass = (status) => {
  switch (status) {
    case 'Thành công':
      return 'bg-success';
    case 'Chờ xác nhận':
      return 'bg-warning text-dark';
    case 'Hủy':
      return 'bg-danger';
    default:
      return 'bg-secondary';
  }
};
</script>

<style scoped>
.container {
  max-width: 900px;
}
.card-header {
  background-color: #f8f9fa;
}
</style>
