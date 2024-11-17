const express = require('express');
const router = express.Router();
const adminController = require('../controllers/adminController');

// Route: Đăng nhập
router.post('/login', adminController.login);

module.exports = router;
