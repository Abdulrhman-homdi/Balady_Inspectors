const express = require('express');
const router = express.Router();
const Ticket = require('../models/Ticket');

// 1. جلب جميع البلاغات (GET) - متوافق مع React وفلاتر
router.get('/', async (req, res) => {
  try {
    const tickets = await Ticket.find().sort({ createdAt: -1 });
    res.json({ success: true, data: tickets });
  } catch (err) {
    res.status(500).json({ success: false, message: 'فشل في جلب البلاغات', error: err.message });
  }
});

// 2. إضافة بلاغ جديد (POST) - تم تنقيته ليعمل بانسيابية مع السيرفر السحابي
router.post('/add', async (req, res) => {
  try {
    console.log("البيانات القادمة من الداشبورد الحين:", req.body);

    const { title, category, description, imageUrl } = req.body;

    const newTicket = new Ticket({ 
      title, 
      category, 
      description: description || '',
      imageUrl: imageUrl || '',
    });

    const savedTicket = await newTicket.save();
    res.status(201).json({ success: true, data: savedTicket });
  } catch (error) {
    console.error("❌ فشل السيرفر في التحقق من البيانات وحفظها:", error.message);
    res.status(400).json({ success: false, error: error.message });
  }
});

// 3. تحديث حالة البلاغ (PUT) - متطابق 100% مع دالة updateStatus بالداشبورد
router.put('/update-status/:id', async (req, res) => {
  try {
    const updateFields = {};
    if (req.body.status) updateFields.status = req.body.status;
    if (req.body.imageUrl !== undefined) updateFields.imageUrl = req.body.imageUrl;
    const ticket = await Ticket.findByIdAndUpdate(
      req.params.id,
      updateFields,
      { new: true, runValidators: true }
    );
    if (!ticket) {
      return res.status(404).json({ success: false, message: 'البلاغ غير موجود' });
    }
    res.json({ success: true, data: ticket });
  } catch (err) {
    res.status(400).json({ success: false, message: 'فشل في تحديث البلاغ', error: err.message });
  }
});

// 4. حذف بلاغ (DELETE)
router.delete('/:id', async (req, res) => {
  try {
    const ticket = await Ticket.findByIdAndDelete(req.params.id);
    if (!ticket) {
      return res.status(404).json({ success: false, message: 'البلاغ غير موجود' });
    }
    res.json({ success: true, message: 'تم حذف البلاغ بنجاح', data: ticket });
  } catch (err) {
    res.status(400).json({ success: false, message: 'فشل في حذف البلاغ', error: err.message });
  }
});

module.exports = router;