<template>
    <table class="table table-bordered">
      <thead>
        <tr>
          <th>#</th>
          <th>Tên Đăng Nhập</th>
          <th>Họ Tên</th>
          <th>Email</th>
          <th>Số Điện Thoại</th>
          <th>Địa Chỉ</th>
          <th>Hành Động</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="(customer, index) in customers" :key="customer.id">
          <td>{{ index + 1 }}</td>
          <td>{{ customer.username }}</td>
          <td>{{ customer.fullname }}</td>
          <td>{{ customer.mail }}</td>
          <td>{{ customer.phone }}</td>
          <td>{{ customer.address }}</td>
          <td>
            <button class="btn btn-primary btn-sm" @click="$emit('edit', customer)">Sửa</button>
            <button class="btn btn-danger btn-sm" @click="$emit('delete', customer.id)">Xóa</button>
          </td>
        </tr>
      </tbody>
    </table>
  </template>
  
  <script setup>
  defineProps({
    customers: Array, // Danh sách khách hàng truyền từ parent
  });
  defineEmits(['edit', 'delete']); // Sự kiện khi sửa hoặc xóa
  </script>
  