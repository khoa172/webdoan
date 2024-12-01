const express = require('express');
const cors = require('cors');
const adminRoutes = require('./routes/admin');
const registerRoutes = require('./routes/registerRoutes');
const customerRoutes = require('./routes/customerRoutes');
const productRoutes = require('./routes/productRoutes');
const brandRoutes = require('./routes/brandRoutes');
const categoryRoutes = require('./routes/categoryRoutes');

const app = express();

// Cấu hình CORS
app.use(cors({
  origin: 'http://localhost:3000', // Frontend chạy trên localhost:3000
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization'],
}));

// Middleware
app.use(express.json()); // Đọc JSON body
app.use(express.urlencoded({ extended: true })); // Đọc URL-encoded body

// Endpoint kiểm tra server
app.get('/', (req, res) => res.send('Backend server is running'));

// Routes
app.use('/api/admin', adminRoutes);
app.use('/api/customersregister', registerRoutes);
app.use('/api/customers', customerRoutes);
app.use('/uploads', express.static('uploads'));
app.use('/api/products', productRoutes);
app.use('/api/brands', brandRoutes);
app.use('/api/categories', categoryRoutes);

// Khởi động server
const PORT = 3001;
app.listen(PORT, () => console.log(`Backend đang chạy tại http://localhost:${PORT}`));
