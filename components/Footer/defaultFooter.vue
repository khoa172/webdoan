<template>
  <v-footer
    class="bg-indigo-lighten-1 text-center d-flex flex-column py-3"
  >
    <div>
      <!-- Lặp qua các biểu tượng trong mảng icons -->
      <v-btn
        v-for="(icon, index) in icons"
        :key="index"
        :icon="icon.icon"
        class="mx-2"
        variant="text"
        :href="icon.link"
        target="_blank"
        color="white"
      ></v-btn>
    </div>

    <v-divider class="my-3"></v-divider>

    <div>
      <p class="mb-2 td">
        <strong>NẾU CẦN SỰ HỖ TRỢ HÃY LIÊN HỆ ĐẾN CHÚNG TÔI THÔNG QUA CÁC SOCIAL MEDIA</strong>
      </p>
      <p class="mb-0">
        <strong>CẢM ƠN BẠN ĐÃ ĐẾN VỚI WEBSITE CỦA CHÚNG TÔI!</strong>
      </p>
    </div>
  </v-footer>
</template>

<script>
export default {
  data() {
    return {
      // Mảng icons bao gồm cả biểu tượng và liên kết
      icons: [
        { icon: "mdi-facebook", link: "https://www.facebook.com" },
        { icon: "mdi-twitter", link: "https://www.twitter.com" },
        { icon: "mdi-instagram", link: "https://www.instagram.com" },
      ],
    };
  },
};
</script>

<style scoped>
.td {
  text-align: center;
  font-size: 0.9rem;
  color: white;
}

.v-footer {
  background-color: #4a148c; /* Màu nền footer */
  color: white; /* Màu chữ */
}

.v-btn {
  transition: transform 0.3s;
}

.v-btn:hover {
  transform: scale(1.1); /* Hiệu ứng khi hover */
}
</style>
