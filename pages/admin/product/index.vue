<template>
  <div class="container mt-5">
    <h1>Quản Lý Sản Phẩm</h1>
    <button class="btn btn-primary mb-3" @click="goToForm">Thêm Sản Phẩm</button>
    <ProductTable :products="products" @edit="editProduct" @delete="deleteProduct" />
  </div>
</template>

<script setup>
definePageMeta({
  layout: 'admin',
});
import { ref, onMounted } from "vue";
import { useRouter } from "vue-router";
import ProductTable from "~/components/ProductTable.vue";
import Swal from "sweetalert2";

const router = useRouter();
const products = ref([]);

const fetchProducts = async () => {
  try {
    products.value = await $fetch("http://localhost:3001/api/products");
  } catch (error) {
    console.error("Lỗi khi lấy danh sách sản phẩm:", error);
  }
};

const goToForm = () => {
  router.push("/admin/product/form");
};

const editProduct = (product) => {
  router.push({
    path: "/admin/product/form",
    query: { id: product.id, product: encodeURIComponent(JSON.stringify(product)) },
  });
};

const deleteProduct = async (id) => {
  const result = await Swal.fire({
    title: "Xác nhận xóa",
    text: "Bạn có chắc chắn muốn xóa sản phẩm này?",
    icon: "warning",
    showCancelButton: true,
    confirmButtonText: "Xóa",
    cancelButtonText: "Hủy",
  });

  if (result.isConfirmed) {
    try {
      await $fetch(`http://localhost:3001/api/products/${id}`, { method: "DELETE" });
      Swal.fire("Đã xóa!", "Sản phẩm đã được xóa thành công.", "success");
      fetchProducts();
    } catch (error) {
      Swal.fire("Lỗi!", "Không thể xóa sản phẩm.", "error");
    }
  }
};

onMounted(() => {
  fetchProducts();
});
</script>
