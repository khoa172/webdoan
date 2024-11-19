const pool = require('../db'); // Kết nối cơ sở dữ liệu
const bcrypt = require('bcrypt'); // Mã hóa mật khẩu

// Lấy danh sách khách hàng
exports.getCustomers = async (req, res) => {
  try {
    const [customers] = await pool.query('SELECT * FROM db_customer');
    res.json(customers);
  } catch (error) {
    console.error('Lỗi khi lấy danh sách khách hàng:', error);
    res.status(500).json({ message: 'Lỗi khi lấy danh sách khách hàng' });
  }
};

// Lấy thông tin một khách hàng theo ID
exports.getCustomerById = async (req, res) => {
  const { id } = req.params;

  try {
    const [rows] = await pool.query('SELECT * FROM db_customer WHERE id = ?', [id]);
    if (rows.length === 0) {
      return res.status(404).json({ message: 'Không tìm thấy khách hàng.' });
    }

    res.json(rows[0]);
  } catch (error) {
    console.error('Lỗi khi lấy thông tin khách hàng:', error);
    res.status(500).json({ message: 'Lỗi khi lấy thông tin khách hàng' });
  }
};

// Lấy thông tin một admin theo ID
exports.getAdminById = async (req, res) => {
  const { id } = req.params;

  try {
    const [rows] = await pool.query('SELECT * FROM db_admin WHERE id = ?', [id]);
    if (rows.length === 0) {
      return res.status(404).json({ message: 'Không tìm thấy admin.' });
    }

    res.json(rows[0]);
  } catch (error) {
    console.error('Lỗi khi lấy thông tin admin:', error);
    res.status(500).json({ message: 'Lỗi khi lấy thông tin admin' });
  }
};

// Cập nhật thông tin khách hàng
exports.updateCustomer = async (req, res) => {
  const { id } = req.params;
  const { fullname, mail, phone, address } = req.body;

  // Kiểm tra dữ liệu đầu vào
  if (!fullname || !mail || !phone || !address) {
    return res.status(400).json({ message: 'Vui lòng điền đầy đủ thông tin' });
  }

  try {
    // Cập nhật thông tin khách hàng
    await pool.query(
      'UPDATE db_customer SET fullname = ?, mail = ?, phone = ?, address = ? WHERE id = ?',
      [fullname, mail, phone, address, id]
    );

    res.json({ message: 'Cập nhật thông tin khách hàng thành công!' });
  } catch (error) {
    console.error('Lỗi khi cập nhật thông tin khách hàng:', error);
    res.status(500).json({ message: 'Lỗi khi cập nhật thông tin khách hàng' });
  }
};

// Xóa khách hàng
exports.deleteCustomer = async (req, res) => {
  const { id } = req.params;

  try {
    // Xóa khách hàng khỏi database
    await pool.query('DELETE FROM db_customer WHERE id = ?', [id]);

    res.json({ message: 'Xóa khách hàng thành công!' });
  } catch (error) {
    console.error('Lỗi khi xóa khách hàng:', error);
    res.status(500).json({ message: 'Lỗi khi xóa khách hàng' });
  }
};
