<template>
  <div class="container mt-5">
    <h2 class="text-center">Đơn Hàng Của Tôi</h2>
    <div v-if="orders.length === 0" class="text-center text-muted mt-4">
      <p>Bạn chưa có đơn hàng nào.</p>
    </div>
    <div v-else>
      <table class="table table-bordered mt-4">
        <thead>
          <tr>
            <th>Mã Đơn Hàng</th>
            <th>Ngày Tạo</th>
            <th>Tổng Tiền</th>
            <th>Trạng Thái</th>
            <th>Chi Tiết</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="order in orders" :key="order.id">
            <td>{{ order.code }}</td>
            <td>{{ order.create_date }}</td>
            <td>{{ formatPrice(order.total_price) }}</td>
            <td>{{ order.status }}</td>
            <td>
              <NuxtLink :to="`/order/${order.id}`" class="btn btn-primary btn-sm">
                Xem Chi Tiết
              </NuxtLink>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';

const orders = ref([]);

const loadOrders = async () => {
  const userId = localStorage.getItem('userId');
  if (userId) {
    try {
      const response = await fetch(`http://localhost:3001/api/orders/${userId}`);
      if (response.ok) {
        orders.value = await response.json();
      } else {
        throw new Error('Không thể tải danh sách đơn hàng');
      }
    } catch (error) {
      console.error(error.message);
    }
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
</script>

<style scoped>
.container {
  max-width: 800px;
  margin: 0 auto;
}
</style>
