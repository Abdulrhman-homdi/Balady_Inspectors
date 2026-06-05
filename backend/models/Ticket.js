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

ticketSchema.pre('save', async function () {
  if (!this.ticketId) {
    const last = await mongoose.model('Ticket').findOne({}, { ticketId: 1 }).sort({ ticketId: -1 });
    const num = last ? parseInt(last.ticketId.replace('#', ''), 10) + 1 : 1;
    this.ticketId = `#${String(num).padStart(6, '0')}`;
  }
});

module.exports = mongoose.model('Ticket', ticketSchema);