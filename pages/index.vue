<template>
  <v-container fluid>
    <v-row>
      <v-col cols="12" md="2">
        <v-card class="py-2 px-3">
          <v-text-field placeholder="Search Product..." v-model="name"></v-text-field>
          <v-radio-group v-model="sortBy">
            <template v-slot:label>
              <h5>Sort By:</h5>
            </template>
            <v-radio value="name">
              <template v-slot:label>
                <div>
                  By <strong>Name</strong>
                </div>
              </template>
            </v-radio>
            <v-radio value="price">
              <template v-slot:label>
                <div>
                  By <strong>Price</strong>
                </div>
              </template>
            </v-radio>
          </v-radio-group>
          <v-radio-group v-model="order">
            <template v-slot:label>
              <h5>Sorting Order:</h5>
            </template>
            <v-radio value="ascending">
              <template v-slot:label>
                <div>
                  By <strong>Ascending</strong>
                </div>
              </template>
            </v-radio>
            <v-radio value="descending">
              <template v-slot:label>
                <div>
                  By <strong>Descending</strong>
                </div>
              </template>
            </v-radio>
          </v-radio-group>
        </v-card>
      </v-col>
      <v-col cols="12" md="10">
        <v-row>
          <v-col
            v-for="(product, i) in filteredProducts"
            :key="i"
            cols="12"
            md="4"
            sm="6"
            lg="3"
          >
            <v-card class="mx-auto">
              <v-img :src="`http://localhost:3001/uploads/${product.image}`" height="240px" cover></v-img>
              <v-card-title class="text-capitalize">{{ product.name }}</v-card-title>
              <v-card-subtitle>{{ product.price }} VND</v-card-subtitle>
              <v-card-actions>
                <v-btn color="orange-lighten-2" text="Explore">Read More</v-btn>
              </v-card-actions>
            </v-card>
          </v-col>
        </v-row>
      </v-col>
    </v-row>
  </v-container>
</template>

<script setup>
import { ref, computed, onMounted, watch } from "vue";
import Swal from "sweetalert2";

const products = ref([]);
const name = ref("");
const sortBy = ref("");
const order = ref("ascending");

// Lấy dữ liệu sản phẩm từ API
const fetchProducts = async () => {
  try {
    const response = await $fetch("http://localhost:3001/api/products");
    products.value = response.map((product) => ({
      ...product,
      image: JSON.parse(product.images || "[]")[0] || "placeholder.jpg", // Lấy hình ảnh đầu tiên
    }));
  } catch (error) {
    console.error("Lỗi khi lấy danh sách sản phẩm:", error);
    Swal.fire("Lỗi", "Không thể tải danh sách sản phẩm", "error");
  }
};

// Lọc sản phẩm dựa trên tên
const filteredProducts = computed(() => {
  let filtered = [...products.value];
  if (name.value) {
    filtered = filtered.filter((product) =>
      name.value
        .toLocaleLowerCase()
        .split(" ")
        .every((v) => product.name.toLocaleLowerCase().includes(v))
    );
  }
  return filtered;
});

// Sắp xếp sản phẩm
const sortProducts = () => {
  const property = sortBy.value;
  if (!property) return;
  const sortOrder = order.value === "descending" ? -1 : 1;
  products.value.sort((a, b) => {
    if (a[property] < b[property]) return -1 * sortOrder;
    if (a[property] > b[property]) return 1 * sortOrder;
    return 0;
  });
};

watch(sortBy, sortProducts);
watch(order, sortProducts);

onMounted(fetchProducts);
</script>
