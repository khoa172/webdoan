<template>
  <v-footer
    class="bg-indigo-lighten-1 text-center d-flex flex-column"
  >
    <div>
      <!-- Lặp qua các biểu tượng trong mảng icons -->
      <v-btn
        v-for="(icon, index) in icons"
        :key="index"
        :icon="icon.icon" 
        class="mx-4"
        variant="text"
        :href="icon.link" 
        target="_blank" 
      ></v-btn>
    </div>

    <div class="pt-0"></div>
    <v-divider></v-divider>

    <div>
      <strong class="td">NẾU CẦN SỰ HỖ TRỢ HÃY LIÊN HỆ CHO CHÚNG TÔI THÔNG QUA CÁC SOCIAL MEDIA</strong> <br>
      <strong>CẢM ƠN BẠN ĐÃ ĐẾN VỚI WEBSITE CỦA CHÚNG TÔI!</strong>
    </div>
  </v-footer>
</template>

<script>
export default {
  data() {
    return {
      // Mảng icons bao gồm cả biểu tượng và liên kết
      icons: [
        { icon: 'mdi-facebook', link: 'https://www.facebook.com' },
        { icon: 'mdi-twitter', link: 'https://www.twitter.com' },
        { icon: 'mdi-instagram', link: 'https://www.instagram.com' },
      ],
    }
  }
}
</script>
<style>

.td{
  text-align: center;
  font-size: 8pt;
}
</style>