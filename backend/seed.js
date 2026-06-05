const API = 'https://balady-api.onrender.com/api/tickets/add';

const samples = [
  { title: 'إنارة مكسورة في حي النزهة', category: 'إنارة', description: 'عمود إنارة مكسور منذ أكثر من أسبوع في شارع الأمير سلطان، مما يشكل خطورة على المارة' },
  { title: 'حفرة في شارع الملك فهد', category: 'حفريات', description: 'حفرة كبيرة في منتصف الشارع بدون حواجز تحذيرية، يرجى المعالجة العاجلة' },
  { title: 'تراكم نفايات في حي الروضة', category: 'نظافة', description: 'لم يتم جمع النفايات منذ 5 أيام في حي الروضة، مما تسبب في انتشار الروائح الكريهة' },
  { title: 'مخالفة بناء في شارع العليا', category: 'مخالفة بناء', description: 'توسعة غير مرخصة في الدور الثالث من المبنى، يتجاوز الحد المسموح به' },
  { title: 'تشوه بصري على جدار المدرسة', category: 'تشوه بصري', description: 'رسومات مشوهة على جدار مدرسة الابتدائية الرابعة، تحتاج إلى صيانة' },
  { title: 'كابل كهرباء مقطوع', category: 'إنارة', description: 'كابل كهرباء مقطوع في شارع التخصصي، يشكل خطراً على المارة' },
  { title: 'نفايات بناء في الموقع', category: 'نظافة', description: 'إلقاء نفايات بناء في أرض فضاء بحي المروج' },
  { title: 'حفريات بدون ترخيص', category: 'حفريات', description: 'حفريات في الشارع دون وجود ترخيص أو لوحات تنظيمية' },
];

async function seed() {
  console.log(`🔄 جاري إضافة ${samples.length} بلاغ عينة...\n`);

  for (const sample of samples) {
    try {
      const res = await fetch(API, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(sample),
      });
      const data = await res.json();
      if (data.success) {
        console.log(`✅ ${data.data.ticketId} - ${sample.title}`);
      } else {
        console.error(`❌ ${sample.title}: ${data.error}`);
      }
    } catch (err) {
      console.error(`❌ ${sample.title}: ${err.message}`);
    }
  }

  console.log('\n🏁 انتهى');
}

seed();
