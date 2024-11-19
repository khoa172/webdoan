<template>
  <div class="container mt-5">
    <h1 class="mb-4">Quản Lý Khách Hàng</h1>
    <CustomerTable
      :customers="customers"
      @edit="editCustomer"
      @delete="deleteCustomer"
    />
  </div>
</template>

<script setup>
definePageMeta({
  layout: 'admin',
});
import { ref, onMounted } from 'vue';
import CustomerTable from '~/components/CustomerTable.vue';
import { useRouter } from 'vue-router';

const customers = ref([]);
const router = useRouter();
const { public: { apiBase } } = useRuntimeConfig();

// Lấy danh sách khách hàng
const fetchCustomers = async () => {
  try {
    customers.value = await $fetch(`${apiBase}/api/customers`);
  } catch (error) {
    console.error('Lỗi khi lấy danh sách khách hàng:', error);
  }
};

// Xóa khách hàng
const deleteCustomer = async (id) => {
  try {
    await $fetch(`${apiBase}/api/customers/${id}`, { method: 'DELETE' });
    fetchCustomers();
  } catch (error) {
    console.error('Lỗi khi xóa khách hàng:', error);
  }
};

// Sửa thông tin khách hàng
const editCustomer = (customer) => {
  router.push({
    path: '/customer/form',
    query: {
      id: customer.id,
      customer: encodeURIComponent(JSON.stringify(customer)),
    },
  });
};

// Lấy dữ liệu khi trang được tải
onMounted(() => {
  fetchCustomers();
});
</script>

