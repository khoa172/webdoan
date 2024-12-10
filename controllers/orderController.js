const db = require("../db");

// API Tạo đơn hàng
exports.createOrder = async (req, res) => {
  console.log("Dữ liệu nhận từ frontend:", req.body);

  const { customer, items, totalPrice } = req.body;

  // Kiểm tra dữ liệu đầu vào
  if (
    !customer ||
    !customer.name ||
    !customer.phone ||
    !customer.email ||
    !customer.address ||
    !Array.isArray(items) ||
    items.length === 0 ||
    typeof totalPrice !== "number"
  ) {
    console.error("Dữ liệu không hợp lệ:", req.body);
    return res.status(400).json({ message: "Dữ liệu không hợp lệ", body: req.body });
  }

  const connection = await db.getConnection(); // Tạo kết nối database
  try {
    await connection.beginTransaction(); // Bắt đầu transaction

    // 1. Tạo đơn hàng trong bảng `db_order`
    const [orderResult] = await connection.query(
      `INSERT INTO db_order 
       (custom_id, customer_name, customer_phone, customer_email, customer_address, total_price, total_num_product, create_date, note, payment_method, status, time, code, date_confirm) 
       VALUES (?, ?, ?, ?, ?, ?, ?, NOW(), ?, 'COD', 'Chờ xác nhận', NOW(), ?, NOW())`,
      [
        customer.id || null,
        customer.name,
        customer.phone,
        customer.email,
        customer.address,
        totalPrice,
        items.length,
        customer.note || "",
        `ORD-${Date.now()}` // Tạo mã đơn hàng duy nhất
      ]
    );

    const orderId = orderResult.insertId;

    // 2. Thêm chi tiết sản phẩm vào bảng `db_detail_order`
    const detailData = items.map((item) => [
      orderId,
      item.id,
      item.quantity,
      item.price * item.quantity,
    ]);

    await connection.query(
      "INSERT INTO db_detail_order (id_order, id_product, qty, sub_total_price) VALUES ?",
      [detailData]
    );

    await connection.commit(); // Commit transaction

    res.status(201).json({
      message: "Đơn hàng đã được tạo thành công",
      orderId,
    });
  } catch (error) {
    await connection.rollback(); // Rollback nếu có lỗi
    console.error("Lỗi khi tạo đơn hàng:", error);
    res.status(500).json({ message: "Đã xảy ra lỗi khi tạo đơn hàng", error: error.message });
  } finally {
    connection.release(); // Giải phóng kết nối
  }
};

// API Lấy danh sách đơn hàng của người dùng
exports.getUserOrders = async (req, res) => {
  const { userId } = req.params;

  if (!userId || isNaN(userId)) {
    return res.status(400).json({ message: "Thiếu thông tin userId hợp lệ" });
  }

  try {
    const [orders] = await db.query(
      `SELECT id, code, total_price, create_date, status 
       FROM db_order WHERE custom_id = ? ORDER BY create_date DESC`,
      [userId]
    );

    if (orders.length === 0) {
      return res.status(404).json({ message: "Không tìm thấy đơn hàng nào" });
    }

    res.status(200).json(orders);
  } catch (error) {
    console.error("Lỗi khi lấy danh sách đơn hàng:", error);
    res.status(500).json({
      message: "Lỗi server khi lấy danh sách đơn hàng",
      error: error.message,
    });
  }
};

// API Lấy chi tiết đơn hàng
exports.getOrderDetails = async (req, res) => {
  const { orderId } = req.params;

  if (!orderId || isNaN(orderId)) {
    return res.status(400).json({ message: "Thiếu thông tin orderId hợp lệ" });
  }

  try {
    const [order] = await db.query(
      `SELECT id, code, total_price, total_num_product, create_date, status, note, customer_name, customer_phone, customer_email, customer_address 
       FROM db_order WHERE id = ?`,
      [orderId]
    );

    if (order.length === 0) {
      return res.status(404).json({ message: "Không tìm thấy thông tin đơn hàng" });
    }

    const [orderItems] = await db.query(
      `SELECT p.name, d.qty AS quantity, d.sub_total_price AS price
       FROM db_detail_order d 
       JOIN db_product p ON d.id_product = p.id
       WHERE d.id_order = ?`,
      [orderId]
    );

    res.status(200).json({ ...order[0], items: orderItems });
  } catch (error) {
    console.error("Lỗi khi lấy chi tiết đơn hàng:", error);
    res.status(500).json({
      message: "Lỗi server khi lấy chi tiết đơn hàng",
      error: error.message,
    });
  }
};
