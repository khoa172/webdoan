const bcrypt = require('bcrypt');
const pool = require('../db'); // Import kết nối database từ db.js

exports.registerUser = async (req, res) => {
  const { username, password, fullname, mail, phone, address } = req.body;

  // Kiểm tra dữ liệu đầu vào
  if (!username || !password || !fullname || !mail || !phone || !address) {
    return res.status(400).json({ message: 'Vui lòng nhập đầy đủ thông tin.' });
  }

  try {
    // Kiểm tra username hoặc email đã tồn tại
    const [existingUser] = await pool.query(
      'SELECT id FROM db_customer WHERE username = ? OR mail = ?',
      [username, mail]
    );
    if (existingUser.length > 0) {
      return res.status(400).json({ message: 'Tên đăng nhập hoặc email đã tồn tại.' });
    }

    // Mã hóa mật khẩu
    const hashedPassword = await bcrypt.hash(password, 10);

    // Lấy thời gian hiện tại để lưu vào create_date
    const createDate = new Date().toISOString(); // Format chuẩn ISO 8601

    // Thêm thông tin người dùng vào database
    await pool.query(
      `INSERT INTO db_customer (username, password, fullname, mail, phone, address, create_date) 
       VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [username, hashedPassword, fullname, mail, phone, address, createDate]
    );

    res.status(201).json({ message: 'Đăng ký thành công!' });
  } catch (error) {
    console.error('Error during user registration:', error);
    res.status(500).json({ message: 'Đã xảy ra lỗi. Vui lòng thử lại sau.' });
  }
};
