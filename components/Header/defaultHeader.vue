<template>
  <div>
    <div class="header-area">
      <div class="container">
        <div class="row">
          <div class="col-md-8">
            <div class="user-menu">
              <ul>
                <li v-if="isLoggedIn">
                  <i class="fa fa-user"></i> 
                  <NuxtLink to="/my-account">My Account</NuxtLink>
                </li>
                <li><a href=""><i class="fa fa-heart"></i> Wishlist</a></li>
                <li><a href=""><i class="fa fa-user"></i> My Cart</a></li>
                <li><a href=""><i class="fa fa-user"></i> Checkout</a></li>
                <li v-if="isLoggedIn">
                  <a href="#" @click.prevent="logout"><i class="fa fa-sign-out"></i> Logout</a>
                </li>
                <li v-else>
                  <i class="fa fa-user"></i> 
                  <NuxtLink to="/auth">Login</NuxtLink>
                </li>
              </ul>
            </div>
          </div>
        </div>
      </div>
    </div> 
    <div class="site-branding-area">
      <div class="container">
        <div class="row align-items-center">
          <div class="col-sm-6">
            <div class="logo">
              <h1><a href="./"><img src="/images/logo.png" alt="logo" class="responsive-img"/></a></h1>
            </div>
          </div>
          <div class="col-sm-6">
            <div class="shopping-item">
              <a href="#">Cart - <span class="cart-amunt">$0</span> <i class="fa fa-shopping-cart"></i></a>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>


<script setup>
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';

const isLoggedIn = ref(false); // Biến kiểm tra trạng thái đăng nhập
const user = ref({});
const router = useRouter();

// Kiểm tra trạng thái đăng nhập khi tải trang
onMounted(() => {
  const token = localStorage.getItem('token');
  const userData = localStorage.getItem('user');
  if (token && userData) {
    isLoggedIn.value = true;
    user.value = JSON.parse(userData);
  }
});

// Xử lý đăng xuất
const logout = () => {
  localStorage.removeItem('token');
  localStorage.removeItem('user');
  isLoggedIn.value = false;
  router.push('/auth'); // Điều hướng đến trang đăng nhập
};
</script>

<style scoped>
.header-area {
  background: none repeat scroll 0 0 #f4f4f4;
}
.header-area a {
  color: #888;
}
.user-menu ul {
  list-style: outside none none;
  margin: 0;
  padding: 0;
}
.user-menu li {
  display: inline-block;
}
.user-menu li a {
  display: block;
  font-size: 13px;
  margin-right: 5px;
  padding: 10px;
}
.user-menu li a i.fa {
  margin-right: 5px;
}
.header-right ul.list-inline {
  margin: 0;
  text-align: right;
}
.header-right ul.list-inline li a {
  display: block;
  padding: 9px;
}
.header-right ul.list-inline li ul a {
  padding: 5px 15px;
}
.header-right ul.list-inline li ul {
  border: medium none;
  border-radius: 0;
  left: 50%;
  margin-left: -50px;
  min-width: 100px;
  text-align: center;
}
.logo {
  width: 15%;
}
.logo h1 {
  font-size: 30px;
  margin: 20px 0;
  font-weight: 400;
}
.logo h1 a {
  color: #999;
}
.logo h1 a:hover {
  text-decoration: none;
  opacity: .7;
}
.logo h1 a span {
  color: #ee5057;
}
.shopping-item {
  border: 1px solid #ddd;
  float: right;
  font-size: 18px;
  margin-top: 40px;
  padding: 10px;
  position: relative;
}
.shopping-item a {
  color: #666;
}
.cart-amunt {
  color: #ee5057;
  font-weight: 700;
}
.product-count {
  background: none repeat scroll 0 0 #ee5057;
  border-radius: 50%;
  color: #fff;
  display: inline-block;
  font-size: 10px;
  height: 20px;
  padding-top: 2px;
  position: absolute;
  right: -10px;
  text-align: center;
  top: -10px;
  width: 20px;
}
.shopping-item i.fa {
  margin-left: 15px;
}
.shopping-item:hover {
  background: none repeat scroll 0 0 #ee5057;
  border-color: #ee5057;
}
.shopping-item:hover a {
  color: #fff;
  text-decoration: none;
}
.shopping-item:hover .cart-amunt {
  color: #fff;
}
.shopping-item:hover .product-count {
  background: none repeat scroll 0 0 #000;
}
.responsive-img {
  width: 100px; 
  height: auto;
}
.align-items-center {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
</style>
