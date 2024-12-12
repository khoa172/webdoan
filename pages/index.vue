<template>
  <div class="container mt-5">
    <div class="row g-4">
      <!-- Sidebar bộ lọc -->
      <div class="col-md-3">
        <div class="card shadow-sm border-0">
          <div class="card-body">
            <h5 class="fw-bold text-primary mb-4">
              <i class="bi bi-funnel-fill me-2"></i>Lọc sản phẩm
            </h5>
            <!-- Tìm kiếm -->
            <div class="mb-4">
              <label class="form-label fw-bold text-muted">
                <i class="bi bi-search me-1"></i>Tìm kiếm
              </label>
              <input
                type="text"
                class="form-control"
                placeholder="Nhập tên sản phẩm..."
                v-model="searchQuery"
              />
            </div>

            <!-- Sắp xếp -->
            <div class="mb-4">
              <label class="form-label fw-bold text-muted">
                <i class="bi bi-sort-alpha-down me-1"></i>Sắp xếp theo
              </label>
              <select class="form-select mb-2" v-model="sortBy">
                <option value="">Mặc định</option>
                <option value="name">Tên sản phẩm</option>
                <option value="price">Giá</option>
              </select>
              <select class="form-select" v-model="sortOrder">
                <option value="asc">Tăng dần</option>
                <option value="desc">Giảm dần</option>
              </select>
            </div>

            <!-- Lọc theo thương hiệu -->
            <div class="mb-4">
              <label class="form-label fw-bold text-muted">
                <i class="bi bi-tags-fill me-1"></i>Thương hiệu
              </label>
              <select class="form-select" v-model="selectedBrand">
                <option value="">Tất cả</option>
                <option
                  v-for="brand in brands"
                  :key="brand.id"
                  :value="brand.id"
                >
                  {{ brand.name }}
                </option>
              </select>
            </div>

            <!-- Lọc theo danh mục -->
            <div class="mb-4">
              <label class="form-label fw-bold text-muted">
                <i class="bi bi-list-ul me-1"></i>Danh mục
              </label>
              <select class="form-select" v-model="selectedCategory">
                <option value="">Tất cả</option>
                <option
                  v-for="category in categories"
                  :key="category.id"
                  :value="category.id"
                >
                  {{ category.name }}
                </option>
              </select>
            </div>

            <!-- Lọc theo RAM -->
            <div>
              <label class="form-label fw-bold text-muted">
                <i class="bi bi-memory me-1"></i>Dung lượng RAM
              </label>
              <select class="form-select" v-model="selectedRam">
                <option value="">Tất cả</option>
                <option v-for="ram in ramOptions" :key="ram" :value="ram">
                  {{ ram }}
                </option>
              </select>
            </div>
          </div>
        </div>
      </div>

      <!-- Danh sách sản phẩm -->
      <div class="col-md-9">
        <div class="d-flex justify-content-between align-items-center mb-4">
          <h4 class="fw-bold text-dark mb-0">Danh Sách Sản Phẩm</h4>
        </div>

        <div class="row g-3">
          <div
            v-for="product in filteredProducts"
            :key="product.id"
            class="col-sm-6 col-md-4"
          >
            <div class="card h-100 shadow-sm border-0">
              <div class="p-3 text-center bg-light">
                <img
                  :src="`http://localhost:3001/uploads/${product.image}`"
                  class="img-fluid"
                  alt="Product Image"
                  style="max-height: 180px; object-fit: contain;"
                />
              </div>
              <div class="card-body">
                <h6 class="card-title text-truncate mb-2 fw-bold">
                  {{ product.name }}
                </h6>
                <p class="card-text text-danger fw-bold mb-3">
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
          <i class="bi bi-emoji-frown fs-1 text-muted"></i>
          <p class="text-muted mt-3">
            Không tìm thấy sản phẩm phù hợp.<br/>
            Hãy thử thay đổi tiêu chí lọc hoặc sắp xếp.
          </p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from "vue";
import { useRouter } from "vue-router";

// State và biến
const products = ref([]);
const brands = ref([]);
const categories = ref([]);
const ramOptions = ref(["4 GB", "6 GB", "8 GB", "12 GB"]); 
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
.container {
  max-width: 1200px;
}

.card {
  border-radius: 10px;
}

.card img {
  border-radius: 10px;
}

.card-title {
  font-size: 1rem;
}

.form-label {
  font-size: 0.9rem;
}

.bi {
  vertical-align: -0.125em; 
}
</style>
