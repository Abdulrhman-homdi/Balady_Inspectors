require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');

const ticketRoutes = require('./routes/ticketRoutes');

const app = express();

// CORS مفتوح لجميع الأصول — يسمح لـ React (Vite) وفلاتر بالاتصال
app.use(cors({
  origin: '*',
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
}));
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ limit: '10mb', extended: true }));

app.get('/', (req, res) => {
  res.json({ message: 'نظام مراقبة البلاغات - API يعمل 🚀' });
});

app.use('/api/tickets', ticketRoutes);

const PORT = process.env.PORT || 5000;

app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 السيرفر يعمل على http://0.0.0.0:${PORT}`);
});

mongoose.connect(process.env.MONGO_URI)
  .then(() => console.log('✅ متصل بـ MongoDB Cloud'))
  .catch((err) => console.error('❌ فشل الاتصال بقاعدة البيانات:', err.message));