import { defineStore } from 'pinia';

export const useCartStore = defineStore('cart', {
  state: () => ({
    id_customer: null, // ID khách hàng
    total_num: 0, // Tổng số lượng sản phẩm trong giỏ hàng
    total_price: 0, // Tổng giá trị giỏ hàng
    items: [], // Mảng sản phẩm trong giỏ hàng
  }),
  actions: {
    /**
     * Lấy thông tin khách hàng từ localStorage khi giỏ hàng được khởi tạo
     */
    initializeCustomer() {
      const userData = localStorage.getItem('user');
      if (userData) {
        const user = JSON.parse(userData);
        this.id_customer = user.id; // Lưu id_customer từ dữ liệu người dùng
      }
    },

    /**
     * Thêm sản phẩm vào giỏ hàng
     * @param {Object} product - Sản phẩm được thêm
     */
    addToCart(product) {
      const existingItem = this.items.find((item) => item.id === product.id);
      if (existingItem) {
        existingItem.quantity += 1; // Nếu sản phẩm đã tồn tại, tăng số lượng
      } else {
        this.items.push({
          ...product,
          quantity: 1,
          image: `http://localhost:3001/uploads/${product.image || product.images[0]}`, // Lấy đường dẫn đầy đủ
        });
      }
      this.updateCartInfo();
      this.saveCartToLocalStorage();
    },

    /**
     * Giảm số lượng sản phẩm trong giỏ hàng
     * @param {Number} productId - ID sản phẩm
     */
    decreaseQuantity(productId) {
      const item = this.items.find((item) => item.id === productId);
      if (item && item.quantity > 1) {
        item.quantity -= 1; // Giảm số lượng sản phẩm
        this.updateCartInfo();
        this.saveCartToLocalStorage();
      } else {
        this.removeFromCart(productId); // Nếu số lượng là 1, xóa sản phẩm khỏi giỏ hàng
      }
    },

    /**
     * Xóa sản phẩm khỏi giỏ hàng
     * @param {Number} productId - ID sản phẩm
     */
    removeFromCart(productId) {
      this.items = this.items.filter((item) => item.id !== productId); // Lọc bỏ sản phẩm khỏi giỏ hàng
      this.updateCartInfo();
      this.saveCartToLocalStorage(); // Lưu lại giỏ hàng sau khi thay đổi
    },

    /**
     * Cập nhật thông tin tổng số lượng và giá trị giỏ hàng
     */
    updateCartInfo() {
      this.total_num = this.items.reduce((total, item) => total + item.quantity, 0);
      this.total_price = this.items.reduce((total, item) => total + item.price * item.quantity, 0);
    },

    /**
     * Xóa toàn bộ giỏ hàng
     */
    clearCart() {
      this.items = [];
      this.updateCartInfo();
      this.saveCartToLocalStorage();
    },

    /**
     * Lưu giỏ hàng vào localStorage
     */
    saveCartToLocalStorage() {
      localStorage.setItem('cart', JSON.stringify(this.items));
    },

    /**
     * Tải giỏ hàng từ localStorage khi trang được tải lại
     */
    loadCartFromLocalStorage() {
      const savedCart = localStorage.getItem('cart');
      if (savedCart) {
        this.items = JSON.parse(savedCart).map((item) => ({
          ...item,
          image: item.image || `http://localhost:3001/uploads/${item.image}`, // Đảm bảo đường dẫn đầy đủ
        }));
        this.updateCartInfo();
      }
    },
  },
});
