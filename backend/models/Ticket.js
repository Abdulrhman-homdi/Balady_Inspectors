const mongoose = require('mongoose');

const ticketSchema = new mongoose.Schema({
  ticketId: {
    type: String,
    unique: true,
  },
  title: {
    type: String,
    required: [true, 'عنوان البلاغ مطلوب'],
    trim: true,
  },
  category: {
    type: String,
    required: [true, 'التصنيف مطلوب'],
    enum: ['مخالفة بناء', 'نظافة', 'إنارة', 'حفريات', 'تشوه بصري'],
  },
  description: {
    type: String,
    trim: true,
  },
  status: {
    type: String,
    enum: ['جديد', 'قيد المعالجة', 'متأخر', 'مصعد', 'منتهي'],
    default: 'جديد',
  },
  imageUrl: {
    type: String,
    default: '',
  },
}, {
  timestamps: true,
});

// تم الإصلاح هنا: إزالة الـ next() والاعتماد على الـ async النقي المتوافق مع Mongoose 9+
ticketSchema.pre('save', async function () {
  if (!this.ticketId) {
    const count = await mongoose.model('Ticket').countDocuments();
    this.ticketId = `#${String(count + 1).padStart(6, '0')}`;
  }
});

module.exports = mongoose.model('Ticket', ticketSchema);