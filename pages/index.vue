<template>
  <div class="container mt-5">
    <div class="row">
      <div class="col-md-3">
        <!-- Sidebar lọc sản phẩm -->
        <div class="card p-3">
          <input
            type="text"
            class="form-control mb-3"
            placeholder="Tìm kiếm..."
            v-model="searchQuery"
          />
          <label>Sort By:</label>
          <select class="form-select mb-3" v-model="sortBy">
            <option value="">Select</option>
            <option value="name">Name</option>
            <option value="price">Price</option>
          </select>
          <label>Order:</label>
          <select class="form-select mb-3" v-model="sortOrder">
            <option value="asc">Ascending</option>
            <option value="desc">Descending</option>
          </select>
          <label>Filter by Brand:</label>
          <select class="form-select mb-3" v-model="selectedBrand">
            <option value="">All Brands</option>
            <option v-for="brand in brands" :key="brand.id" :value="brand.id">
              {{ brand.name }}
            </option>
          </select>
          <label>Filter by Category:</label>
          <select class="form-select mb-3" v-model="selectedCategory">
            <option value="">All Categories</option>
            <option
              v-for="category in categories"
              :key="category.id"
              :value="category.id"
            >
              {{ category.name }}
            </option>
          </select>
          <label>Filter by RAM:</label>
          <select class="form-select" v-model="selectedRam">
            <option value="">All RAM</option>
            <option v-for="ram in ramOptions" :key="ram" :value="ram">
              {{ ram }}
            </option>
          </select>
        </div>
      </div>

      <div class="col-md-9">
        <div class="row">
          <div
            class="col-md-4 mb-4"
            v-for="product in filteredProducts"
            :key="product.id"
          >
            <div class="card h-100">
              <img
                :src="`http://localhost:3001/uploads/${product.image}`"
                class="card-img-top"
                alt="Product Image"
              />
              <div class="card-body">
                <h5 class="card-title">{{ product.name }}</h5>
                <p class="card-text">{{ product.price }} VND</p>
                <button
                  class="btn btn-primary"
                  @click="goToDetail(product.id)"
                >
                  Xem Chi Tiết
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from "vue";
import { useRouter } from "vue-router";

const products = ref([]);
const brands = ref([]);
const categories = ref([]);
const ramOptions = ref(["4 GB", "6 GB", "8 GB", "12 GB"]); // Các tùy chọn RAM
const searchQuery = ref("");
const sortBy = ref("");
const sortOrder = ref("asc");
const selectedBrand = ref("");
const selectedCategory = ref("");
const selectedRam = ref("");
const router = useRouter();

// Lấy danh sách sản phẩm, thương hiệu, danh mục
const fetchProducts = async () => {
  try {
    const response = await $fetch("http://localhost:3001/api/products");
    products.value = response.map((product) => ({
      ...product,
      image: JSON.parse(product.images || "[]")[0] || "placeholder.jpg",
    }));
  } catch (error) {
    console.error("Lỗi khi lấy danh sách sản phẩm:", error);
  }
};

const fetchBrandsAndCategories = async () => {
  try {
    brands.value = await $fetch("http://localhost:3001/api/brands");
    categories.value = await $fetch("http://localhost:3001/api/categories");
  } catch (error) {
    console.error("Lỗi khi lấy danh sách thương hiệu và danh mục:", error);
  }
};

// Lọc và sắp xếp sản phẩm
const filteredProducts = computed(() => {
  let filtered = [...products.value];

  if (searchQuery.value) {
    filtered = filtered.filter((p) =>
      p.name.toLowerCase().includes(searchQuery.value.toLowerCase())
    );
  }

  if (selectedBrand.value) {
    filtered = filtered.filter((p) => p.id_brand === selectedBrand.value);
  }

  if (selectedCategory.value) {
    filtered = filtered.filter((p) => p.id_category === selectedCategory.value);
  }

  if (selectedRam.value) {
    filtered = filtered.filter((p) => p.ram === selectedRam.value);
  }

  if (sortBy.value) {
    filtered.sort((a, b) => {
      if (sortOrder.value === "asc") {
        return a[sortBy.value] > b[sortBy.value] ? 1 : -1;
      }
      return a[sortBy.value] < b[sortBy.value] ? 1 : -1;
    });
  }

  return filtered;
});

const goToDetail = (productId) => {
  router.push(`/product/${productId}`);
};

onMounted(async () => {
  await fetchProducts();
  await fetchBrandsAndCategories();
});
</script>
