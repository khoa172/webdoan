import { defineStore } from 'pinia';

export const useCartStore = defineStore('cart', {
  state: () => ({
    id_customer: null, // ID khách hàng
    total_num: 0, // Tổng số lượng sản phẩm trong giỏ hàng
    total_price: 0, // Tổng giá trị giỏ hàng
    items: [], // Mảng sản phẩm trong giỏ hàng
  }),
  actions: {
    // Lấy thông tin khách hàng (id_customer) từ localStorage khi giỏ hàng được khởi tạo
    initializeCustomer() {
      const userData = localStorage.getItem('user');
      if (userData) {
        const user = JSON.parse(userData);
        this.id_customer = user.id; // Lưu id_customer từ dữ liệu người dùng
      }
    },

    // Thêm sản phẩm vào giỏ hàng
    addToCart(product) {
        const existingItem = this.items.find((item) => item.id === product.id);
        if (existingItem) {
          existingItem.quantity += 1; // Nếu sản phẩm đã có trong giỏ hàng, tăng số lượng
        } else {
          this.items.push({ ...product, quantity: 1 }); // Thêm sản phẩm mới vào giỏ hàng
        }
        this.updateCartInfo();
        this.saveCartToLocalStorage(); // Lưu lại giỏ hàng sau khi thay đổi
    },

    // Cập nhật thông tin giỏ hàng
    updateCartInfo() {
      this.total_num = this.items.reduce((total, item) => total + item.quantity, 0);
      this.total_price = this.items.reduce((total, item) => total + item.price * item.quantity, 0);
    },

    // Xóa sản phẩm khỏi giỏ hàng
    removeFromCart(productId) {
        this.items = this.items.filter((item) => item.id !== productId);
        this.updateCartInfo();
        this.saveCartToLocalStorage(); // Lưu lại giỏ hàng sau khi thay đổi
    },

    // Xóa tất cả sản phẩm trong giỏ hàng
    clearCart() {
      this.items = [];
      this.updateCartInfo();
    },
    // Lưu giỏ hàng vào localStorage
    saveCartToLocalStorage() {
        localStorage.setItem('cart', JSON.stringify(this.items));
    },
    
    // Tải giỏ hàng từ localStorage khi trang được tải lại
    loadCartFromLocalStorage() {
        const savedCart = localStorage.getItem('cart');
        if (savedCart) {
        this.items = JSON.parse(savedCart);
        this.updateCartInfo();
        }
     },
  },
});