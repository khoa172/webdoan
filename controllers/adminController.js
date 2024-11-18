const pool = require('../db'); // Kết nối cơ sở dữ liệu
const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');
const SECRET_KEY = 'your-secret-key'; // Khóa JWT

exports.login = async (req, res) => {
  const { username, password } = req.body;

  try {
    // Truy vấn từ cơ sở dữ liệu
    const [adminRows] = await pool.query('SELECT * FROM db_admin WHERE username = ?', [username]);
    if (adminRows.length === 0) {
      return res.status(401).json({ message: 'Tên đăng nhập không tồn tại' });
    }
    if (adminRows.length > 0) {
      const admin = adminRows[0];

      // Kiểm tra mật khẩu
      if (password !== admin.password) {
        return res.status(401).json({ message: 'Mật khẩu không đúng' });
      }

      // Tạo token JWT
      const token = jwt.sign({ id: admin.id, role: admin.role }, SECRET_KEY, { expiresIn: '1h' });

      return res.json({
        message: 'Đăng nhập thành công',
        token,
        user: { id: admin.id, username: admin.username, fullname: admin.fullname, role: admin.role },
      });
    }

    // Kiểm tra trong bảng db_customer
    const [customerRows] = await pool.query('SELECT * FROM db_customer WHERE username = ?', [username]);

    if (customerRows.length > 0) {
      const customer = customerRows[0];

      // Kiểm tra mật khẩu
      if (!bcrypt.compareSync(password, customer.password)) {
        return res.status(401).json({ message: 'Mật khẩu không đúng.' });
      }

      // Tạo token JWT cho customer
      const token = jwt.sign({ id: customer.id, role: 'customer' }, SECRET_KEY, { expiresIn: '1h' });

      return res.json({
        message: 'Đăng nhập thành công với vai trò customer',
        token,
        user: { id: customer.id, username: customer.username, fullname: customer.fullname, role: 'customer' },
      });
    }

    // Không tìm thấy tài khoản
    return res.status(401).json({ message: 'Tên đăng nhập không tồn tại.' });

  } catch (err) {
    console.error('Lỗi khi đăng nhập:', err.message);
    res.status(500).json({ error: 'Lỗi server' });
  }
};
