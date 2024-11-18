const express = require('express');
const cors = require('cors');
const adminRoutes = require('./routes/admin');
const registerRoutes = require('./routes/registerRoutes');
const app = express();

app.use(cors({
  origin: 'http://localhost:3000', // Frontend chạy trên localhost:3000
  methods: ['GET', 'POST'],
  allowedHeaders: ['Content-Type', 'Authorization'],
}));

app.use(express.json());

// Route kiểm tra
app.get('/', (req, res) => res.send('Backend server is running'));

// Đăng ký routes
app.use('/api/admin', adminRoutes);
app.use('/api/customers', registerRoutes);
// Khởi động server
const PORT = 3001;
app.listen(PORT, () => console.log(`Backend đang chạy tại http://localhost:${PORT}`));
