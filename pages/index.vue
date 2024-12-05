<template>
  <div class="container mt-5">
    <div class="row">
      <!-- Sidebar bộ lọc -->
      <div class="col-md-3">
        <div class="card shadow-sm p-3 mb-4">
          <h5 class="fw-bold text-primary mb-3">Lọc sản phẩm</h5>
          <!-- Tìm kiếm -->
          <input
            type="text"
            class="form-control mb-3"
            placeholder="Tìm kiếm sản phẩm..."
            v-model="searchQuery"
          />

          <!-- Sắp xếp -->
          <h6 class="fw-bold">Sắp xếp theo</h6>
          <select class="form-select mb-3" v-model="sortBy">
            <option value="">Mặc định</option>
            <option value="name">Tên sản phẩm</option>
            <option value="price">Giá</option>
          </select>
          <select class="form-select mb-3" v-model="sortOrder">
            <option value="asc">Tăng dần</option>
            <option value="desc">Giảm dần</option>
          </select>

          <!-- Lọc theo thương hiệu -->
          <h6 class="fw-bold">Thương hiệu</h6>
          <select class="form-select mb-3" v-model="selectedBrand">
            <option value="">Tất cả</option>
            <option v-for="brand in brands" :key="brand.id" :value="brand.id">
              {{ brand.name }}
            </option>
          </select>

          <!-- Lọc theo danh mục -->
          <h6 class="fw-bold">Danh mục</h6>
          <select class="form-select mb-3" v-model="selectedCategory">
            <option value="">Tất cả</option>
            <option v-for="category in categories" :key="category.id" :value="category.id">
              {{ category.name }}
            </option>
          </select>

          <!-- Lọc theo RAM -->
          <h6 class="fw-bold">Dung lượng RAM</h6>
          <select class="form-select" v-model="selectedRam">
            <option value="">Tất cả</option>
            <option v-for="ram in ramOptions" :key="ram" :value="ram">
              {{ ram }}
            </option>
          </select>
        </div>
      </div>

      <!-- Danh sách sản phẩm -->
      <div class="col-md-9">
        <div class="row">
          <div
            v-for="product in filteredProducts"
            :key="product.id"
            class="col-md-4 mb-4"
          >
            <div class="card h-100 shadow-sm">
              <img
                :src="`http://localhost:3001/uploads/${product.image}`"
                class="card-img-top"
                alt="Product Image"
              />
              <div class="card-body">
                <h6 class="card-title text-truncate">{{ product.name }}</h6>
                <p class="card-text text-danger fw-bold">
                  {{ formatPrice(product.price) }}
                </p>
                <button
                  class="btn btn-primary btn-sm w-100"
                  @click="goToDetail(product.id)"
                >
                  Xem Chi Tiết
                </button>
              </div>
            </div>
          </div>
        </div>

        <!-- Thông báo khi không có sản phẩm -->
        <div v-if="filteredProducts.length === 0" class="text-center mt-5">
          <p class="text-muted">Không tìm thấy sản phẩm phù hợp.</p>
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

const formatPrice = (price) => {
  return new Intl.NumberFormat("vi-VN", {
    style: "currency",
    currency: "VND",
  }).format(price);
};

onMounted(async () => {
  await fetchProducts();
  await fetchBrandsAndCategories();
});
</script>

<style scoped>
.card {
  border-radius: 10px;
}

.card img {
  max-height: 200px;
  object-fit: contain; /* Hiển thị đầy đủ hình ảnh mà không bị cắt */
  border-radius: 10px 10px 0 0;
  width: 100%;
}

.card-title {
  font-size: 1rem;
  font-weight: bold;
}

.card-text {
  font-size: 0.9rem;
}

.card .btn {
  margin-top: 10px;
}

.container {
  max-width: 1200px;
}
</style>
