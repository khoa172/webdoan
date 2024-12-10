<template>
    <table class="table table-bordered table-striped">
      <thead class="table-dark">
        <tr>
          <th>#</th>
          <th>Mã Đơn Hàng</th>
          <th>Khách Hàng</th>
          <th>Số Lượng</th>
          <th>Tổng Tiền</th>
          <th>Trạng Thái</th>
          <th>Hành Động</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="(order, index) in orders" :key="order.id">
          <td>{{ index + 1 }}</td>
          <td>{{ order.code }}</td>
          <td>{{ order.customer_name }}</td>
          <td>{{ order.total_num_product }}</td>
          <td>{{ formatPrice(order.total_price) }}</td>
          <td>
            <span :class="['badge', getStatusClass(order.status)]">
              {{ order.status }}
            </span>
          </td>
          <td>
            <button
              class="btn btn-primary btn-sm me-2"
              @click="$emit('view', order)"
            >
              Xem
            </button>
            <button
              class="btn btn-danger btn-sm"
              @click="$emit('delete', order.id)"
            >
              Xóa
            </button>
          </td>
        </tr>
      </tbody>
    </table>
  </template>
  
  <script setup>
  defineProps({
  orders: {
    type: Array,
    required: true,
  },
});
  const formatPrice = (price) => {
    return new Intl.NumberFormat("vi-VN", {
      style: "currency",
      currency: "VND",
    }).format(price);
  };
  
  const getStatusClass = (status) => {
    switch (status) {
      case "Thành công":
        return "bg-success";
      case "Chờ xác nhận":
        return "bg-warning text-dark";
      case "Hủy":
        return "bg-danger";
      default:
        return "bg-secondary";
    }
  };
  </script>
  
  <style scoped>
  .table {
    margin-top: 20px;
  }
  
  .badge {
    padding: 0.5em;
    border-radius: 5px;
  }
  </style>
  