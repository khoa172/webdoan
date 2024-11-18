const express = require('express');
const { registerUser } = require('../controllers/registerController');

const router = express.Router();

// Định tuyến cho đăng ký
router.post('/register', registerUser);

module.exports = router;
