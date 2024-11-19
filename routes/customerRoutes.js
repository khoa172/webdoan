const express = require('express');
const router = express.Router();
const customerController = require('../controllers/customerController');

// Lấy danh sách khách hàng
router.get('/', customerController.getCustomers);
// Lấy thông tin khách hàng theo ID
router.get('/:id', customerController.getCustomerById);
// Cập nhật thông tin khách hàng
router.put('/:id', customerController.updateCustomer);
// Route quản lý admin
router.get('/admin/:id', customerController.getAdminById);
// Xóa khách hàng
router.delete('/:id', customerController.deleteCustomer);

module.exports = router;
