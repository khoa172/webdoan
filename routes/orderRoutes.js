const express = require("express");
const router = express.Router();
const orderController = require("../controllers/orderController");

// Route tạo đơn hàng
router.post("/", orderController.createOrder);

// Route lấy danh sách đơn hàng theo userId
router.get("/:userId", orderController.getUserOrders);

router.get('/details/:orderId', orderController.getOrderDetails);

module.exports = router;
