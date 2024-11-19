const express = require('express');
const cors = require('cors');
const adminRoutes = require('./routes/admin');
const registerRoutes = require('./routes/registerRoutes');
const customerRoutes = require('./routes/customerRoutes');
const app = express();

app.use(cors({
  origin: 'http://localhost:3000', // Frontend chạy trên localhost:3000
  methods: ['GET', 'POST','PUT','DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization'],
}));

app.use(express.json());


app.get('/', (req, res) => res.send('Backend server is running'));


app.use('/api/admin', adminRoutes);
app.use('/api/customersregister', registerRoutes);
app.use('/api/customers', customerRoutes);

const PORT = 3001;
app.listen(PORT, () => console.log(`Backend đang chạy tại http://localhost:${PORT}`));
