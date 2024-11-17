const pool = require('../db'); // Kết nối cơ sở dữ liệu
const jwt = require('jsonwebtoken');

const SECRET_KEY = 'your-secret-key'; // Khóa JWT

exports.login = async (req, res) => {
  const { username, password } = req.body;

  try {
    // Truy vấn từ cơ sở dữ liệu
    const [rows] = await pool.query('SELECT * FROM db_admin WHERE username = ?', [username]);
    if (rows.length === 0) {
      return res.status(401).json({ message: 'Tên đăng nhập không tồn tại' });
    }

    const admin = rows[0];

    // Kiểm tra mật khẩu
    if (password !== admin.password) {
      return res.status(401).json({ message: 'Mật khẩu không đúng' });
    }

    // Tạo token JWT
    const token = jwt.sign({ id: admin.id, username: admin.username }, SECRET_KEY, { expiresIn: '1h' });

    res.json({
      message: 'Đăng nhập thành công',
      token,
      admin: { id: admin.id, username: admin.username, fullname: admin.fullname },
    });
  } catch (err) {
    console.error('Lỗi khi đăng nhập:', err.message);
    res.status(500).json({ error: 'Lỗi server' });
  }
};
