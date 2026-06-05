const mongoose = require('mongoose');

const progressEntrySchema = new mongoose.Schema({
  action: { type: String, required: true },
  details: { type: String, default: '' },
  assignee: { type: String, default: '' },
  createdAt: { type: Date, default: Date.now },
}, { _id: false });

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
  location: {
    address: { type: String, default: '' },
    district: { type: String, default: '' },
    lat: { type: Number, default: 24.7136 },
    lng: { type: Number, default: 46.6753 },
    landmark: { type: String, default: '' },
  },
  progressLog: [progressEntrySchema],
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