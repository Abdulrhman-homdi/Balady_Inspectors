import { useState, useEffect, useRef } from 'react';
import axios from 'axios';

const API_BASE = import.meta.env.VITE_API_URL || '/api';

const STATUS_CONFIG = {
  'جديد': { color: 'bg-blue-100 text-blue-700', dot: 'bg-blue-500' },
  'قيد المعالجة': { color: 'bg-orange-100 text-orange-700', dot: 'bg-orange-500' },
  'متأخر': { color: 'bg-red-100 text-red-700', dot: 'bg-red-500' },
  'مصعد': { color: 'bg-purple-100 text-purple-700', dot: 'bg-purple-500' },
  'منتهي': { color: 'bg-green-100 text-green-700', dot: 'bg-green-500' },
};

const CATEGORIES = ['مخالفة بناء', 'نظافة', 'إنارة', 'حفريات', 'تشوه بصري'];

export default function App() {
  const [tickets, setTickets] = useState([]);
  const [form, setForm] = useState({ title: '', category: '', description: '', imageUrl: '' });
  const [submitting, setSubmitting] = useState(false);
  const [selectedTicket, setSelectedTicket] = useState(null);
  const fileInputRef = useRef(null);

  const fetchTickets = async () => {
    try {
      const res = await axios.get(`${API_BASE}/tickets`);
      if (res.data && res.data.success && Array.isArray(res.data.data)) {
        setTickets(res.data.data);
      }
    } catch (err) {
      console.warn('تعذر الاتصال بالخادم لجلب البيانات:', err);
    }
  };

  const deleteTicket = async (id) => {
    if (!window.confirm('هل أنت متأكد من حذف هذا البلاغ؟')) return;
    try {
      await axios.delete(`${API_BASE}/tickets/${id}`);
      await fetchTickets();
    } catch (err) {
      console.error('Delete Error:', err);
      alert('فشل حذف البلاغ');
    }
  };

  useEffect(() => {
    fetchTickets();
  }, []);

  const handleInput = (e) => setForm((prev) => ({ ...prev, [e.target.name]: e.target.value }));

  const handleFileChange = (e) => {
    const file = e.target.files[0];
    if (!file) return;
    if (file.size > 2 * 1024 * 1024) {
      alert('⚠️ عذراً، حجم الصورة يتجاوز الحد المسموح به! لضمان كفاءة التخزين السحابي، الحد الأقصى هو 2 ميجابايت فقط. يرجى اختيار صورة أخرى أو تقليل جودتها.');
      if (fileInputRef.current) fileInputRef.current.value = '';
      return;
    }
    const reader = new FileReader();
    reader.onload = () => {
      setForm((prev) => ({ ...prev, imageUrl: reader.result }));
    };
    reader.readAsDataURL(file);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!form.title || !form.category) return alert('الرجاء تعبئة الحقول الأساسية');
    
    setSubmitting(true);
    try {
      const res = await axios.post(`${API_BASE}/tickets/add`, form);
      if (res.data && res.data.success) {
        await fetchTickets();
        setForm({ title: '', category: '', description: '', imageUrl: '' });
        alert('✅ تم إضافة البلاغ بنجاح في قاعدة بيانات MongoDB Cloud!');
      }
    } catch (err) {
      console.error('Submission Error:', err);
      alert('لم يتم إرسال البلاغ. تأكد من تشغيل السيرفر على منفذ 5000 وتفعيل الـ CORS.');
    } finally {
      setSubmitting(false);
    }
  };

  const updateStatus = async (id, newStatus) => {
    const prev = [...tickets];
    setTickets((prevList) => prevList.map((t) => (t._id === id ? { ...t, status: newStatus } : t)));
    try {
      await axios.put(`${API_BASE}/tickets/update-status/${id}`, { status: newStatus });
    } catch (err) {
      console.error('Update Status Error:', err);
      setTickets(prev);
    }
  };

  const kpis = [
    { label: 'إجمالي البلاغات', count: tickets.length, color: 'text-[#1B8354]', bg: 'bg-[#E8F5EE]' },
    { label: 'جديد', count: tickets.filter((t) => t.status === 'جديد').length, color: 'text-blue-600', bg: 'bg-blue-50' },
    { label: 'قيد المعالجة', count: tickets.filter((t) => t.status === 'قيد المعالجة').length, color: 'text-orange-600', bg: 'bg-orange-50' },
    { label: 'متأخر', count: tickets.filter((t) => t.status === 'متأخر').length, color: 'text-red-600', bg: 'bg-red-50' },
    { label: 'منتهي', count: tickets.filter((t) => t.status === 'منتهي').length, color: 'text-green-600', bg: 'bg-green-50' },
  ];

  return (
    <div className="min-h-screen bg-[#F8F9FA]" dir="rtl">
      <Header />
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6 space-y-6">
        <KpiRow items={kpis} />
        <div className="grid grid-cols-1 xl:grid-cols-3 gap-6">
          <div className="xl:col-span-1">
            <TicketForm
              form={form}
              onChange={handleInput}
              onFileChange={handleFileChange}
              onSubmit={handleSubmit}
              submitting={submitting}
              fileInputRef={fileInputRef}
            />
          </div>
          <div className="xl:col-span-2">
            <TicketTable
              tickets={tickets}
              onStatusChange={updateStatus}
              onDelete={deleteTicket}
              onViewDetails={setSelectedTicket}
              onRefresh={fetchTickets}
            />
          </div>
        </div>
      </main>
      {selectedTicket && (
        <DetailModal ticket={selectedTicket} onClose={() => setSelectedTicket(null)} />
      )}
    </div>
  );
}

/* ── Header ── */
function Header() {
  return (
    <header className="bg-white shadow-[0_1px_3px_rgba(0,0,0,0.05)]">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="w-11 h-11 bg-[#E8F5EE] rounded-lg flex items-center justify-center">
              <svg className="w-6 h-6 text-[#1B8354]" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={1.5}>
                <path strokeLinecap="round" strokeLinejoin="round" d="M2.25 21h19.5m-18-18v18m10.5-18v18m6-13.5V21M6.75 6.75h.75m-.75 3h.75m-.75 3h.75m3-6h.75m-.75 3h.75m-.75 3h.75M6.75 21v-3.375c0-.621.504-1.125 1.125-1.125h2.25c.621 0 1.125.504 1.125 1.125V21M3 3h12m-.75 4.5H21m-3.75 3.75h.008v.008h-.008v-.008Z" />
              </svg>
            </div>
            <div className="text-right">
              <h1 className="text-base font-bold text-gray-900">اسم الأمانة باللغة العربية</h1>
              <p className="text-xs text-gray-500">Name of Municipality in English</p>
            </div>
          </div>
          <div className="flex items-center gap-2">
            <div className="w-8 h-8 bg-[#1B8354] rounded-full flex items-center justify-center text-white text-sm font-bold">
              ت
            </div>
            <span className="text-sm font-semibold text-gray-800">م. تركي بن عبدالرحمن</span>
          </div>
        </div>
      </div>
    </header>
  );
}

/* ── KPI Row ── */
function KpiRow({ items }) {
  return (
    <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-5 gap-4">
      {items.map((kpi) => (
        <div key={kpi.label} className="bg-white rounded-lg shadow-[0_4px_6px_-1px_rgba(0,0,0,0.05)] p-5 text-center">
          <p className="text-sm text-gray-500 font-medium mb-2">{kpi.label}</p>
          <p className={`text-3xl font-bold ${kpi.color}`}>{kpi.count}</p>
        </div>
      ))}
    </div>
  );
}

/* ── Ticket Form ── */
function TicketForm({ form, onChange, onFileChange, onSubmit, submitting, fileInputRef }) {
  return (
    <div className="bg-white rounded-lg shadow-[0_4px_6px_-1px_rgba(0,0,0,0.05)] p-6">
      <h2 className="text-lg font-bold text-gray-900 mb-5">إضافة بلاغ جديد</h2>
      <form onSubmit={onSubmit} className="space-y-4">
        <div>
          <label className="block text-sm font-semibold text-gray-700 mb-1.5">عنوان البلاغ</label>
          <input
            type="text"
            name="title"
            value={form.title}
            onChange={onChange}
            placeholder="أدخل عنوان البلاغ"
            className="w-full px-4 py-2.5 border border-gray-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#1B8354]/20 focus:border-[#1B8354]"
            required
          />
        </div>
        <div>
          <label className="block text-sm font-semibold text-gray-700 mb-1.5">التصنيف</label>
          <select
            name="category"
            value={form.category}
            onChange={onChange}
            className="w-full px-4 py-2.5 border border-gray-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#1B8354]/20 focus:border-[#1B8354]"
            required
          >
            <option value="">اختر التصنيف</option>
            {CATEGORIES.map((cat) => (
              <option key={cat} value={cat}>{cat}</option>
            ))}
          </select>
        </div>
        <div>
          <label className="block text-sm font-semibold text-gray-700 mb-1.5">صورة البلاغ</label>
          <input
            type="file"
            accept="image/*"
            ref={fileInputRef}
            onChange={onFileChange}
            className="w-full text-sm text-gray-500 file:ml-4 file:py-2 file:px-4 file:rounded-lg file:border-0 file:text-sm file:font-semibold file:bg-[#1B8354]/10 file:text-[#1B8354] hover:file:bg-[#1B8354]/20 cursor-pointer"
          />
          <p className="text-xs text-gray-400 mt-1.5">الحد الأقصى لحجم الصورة الميدانية: 2 ميجابايت لحفظ المساحة السحابية</p>
          {form.imageUrl && (
            <img
              src={form.imageUrl}
              alt="معاينة"
              className="mt-2 w-full h-32 object-cover rounded-lg border border-gray-200"
            />
          )}
        </div>
        <div>
          <label className="block text-sm font-semibold text-gray-700 mb-1.5">تفاصيل البلاغ</label>
          <textarea
            name="description"
            value={form.description}
            onChange={onChange}
            rows={4}
            placeholder="أدخل تفاصيل البلاغ"
            className="w-full px-4 py-2.5 border border-gray-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#1B8354]/20 focus:border-[#1B8354] resize-none"
            required
          />
        </div>
        <button
          type="submit"
          disabled={submitting}
          className="w-full py-3 bg-[#1B8354] text-white font-bold rounded-lg text-sm hover:bg-[#146A43] transition-colors disabled:opacity-50 flex items-center justify-center gap-2"
        >
          {submitting && (
            <svg className="animate-spin h-4 w-4 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
              <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" />
              <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
            </svg>
          )}
          {submitting ? 'جاري إضافة البلاغ...' : 'إضافة البلاغ'}
        </button>
      </form>
    </div>
  );
}

/* ── Ticket Table ── */
function TicketTable({ tickets, onStatusChange, onDelete, onViewDetails, onRefresh }) {
  return (
    <div className="bg-white rounded-lg shadow-[0_4px_6px_-1px_rgba(0,0,0,0.05)] p-6">
      <div className="flex items-center justify-between mb-5">
        <button
          onClick={onRefresh}
          className="flex items-center gap-1.5 px-3 py-1.5 text-xs font-semibold text-[#1B8354] bg-[#E8F5EE] hover:bg-[#1B8354]/20 rounded-lg transition-colors"
        >
          <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
            <path strokeLinecap="round" strokeLinejoin="round" d="M16.023 9.348h4.992v-.001M2.985 19.644v-4.992m0 0h4.992m-4.993 0 3.181 3.183a8.25 8.25 0 0 0 13.803-3.7M4.031 9.865a8.25 8.25 0 0 1 13.803-3.7l3.181 3.182" />
          </svg>
          تحديث البيانات
        </button>
        <h2 className="text-lg font-bold text-gray-900">جدول مراقبة البلاغات</h2>
      </div>
      <div className="overflow-x-auto">
        <table className="w-full text-sm">
          <thead>
            <tr className="border-b border-gray-100">
              <th className="text-right py-3 px-3 font-semibold text-gray-600">رقم البلاغ</th>
              <th className="text-right py-3 px-3 font-semibold text-gray-600">العنوان</th>
              <th className="text-right py-3 px-3 font-semibold text-gray-600">التصنيف</th>
              <th className="text-right py-3 px-3 font-semibold text-gray-600">تاريخ الإدراج</th>
              <th className="text-right py-3 px-3 font-semibold text-gray-600">الحالة</th>
              <th className="text-right py-3 px-3 font-semibold text-gray-600">إجراء</th>
            </tr>
          </thead>
          <tbody>
            {tickets.map((ticket) => {
              const cfg = STATUS_CONFIG[ticket.status] || STATUS_CONFIG['جديد'];
              const shortId = ticket._id ? `${ticket._id.substring(0, 6).toUpperCase()}#` : '#000000';
              
              return (
                <tr key={ticket._id} className="border-b border-gray-50 hover:bg-gray-50/50 transition-colors">
                  <td className="py-3 px-3 text-gray-400 font-mono text-xs">{shortId}</td>
                  <td className="py-3 px-3">
                    <div className="flex items-center gap-3">
                      {ticket.imageUrl ? (
                        <img
                          src={ticket.imageUrl}
                          alt=""
                          className="w-14 h-14 rounded-xl object-cover border border-gray-100 shrink-0"
                        />
                      ) : (
                        <div className="w-14 h-14 rounded-xl bg-gray-100 shrink-0 flex items-center justify-center">
                          <svg className="w-6 h-6 text-gray-300" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={1.5}>
                            <path strokeLinecap="round" strokeLinejoin="round" d="m2.25 15.75 5.159-5.159a2.25 2.25 0 0 1 3.182 0l5.159 5.159m-1.5-1.5 1.409-1.409a2.25 2.25 0 0 1 3.182 0l2.909 2.909M3.75 21h16.5A2.25 2.25 0 0 0 22.5 18.75V5.25A2.25 2.25 0 0 0 20.25 3H3.75A2.25 2.25 0 0 0 1.5 5.25v13.5A2.25 2.25 0 0 0 3.75 21Z" />
                          </svg>
                        </div>
                      )}
                      <span className="font-semibold text-gray-900">{ticket.title}</span>
                    </div>
                  </td>
                  <td className="py-3 px-3 text-gray-600">{ticket.category}</td>
                  <td className="py-3 px-3 text-gray-500">{ticket.createdAt ? new Date(ticket.createdAt).toLocaleDateString('ar-SA') : ''}</td>
                  <td className="py-3 px-3">
                    <span className={`inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-semibold ${cfg.color}`}>
                      <span className={`w-1.5 h-1.5 rounded-full ${cfg.dot}`} />
                      {ticket.status}
                    </span>
                  </td>
                  <td className="py-3 px-3">
                    <div className="flex items-center gap-2">
                      <button
                        onClick={() => onViewDetails(ticket)}
                        className="text-xs px-3 py-1.5 bg-[#1B8354]/10 text-[#1B8354] hover:bg-[#1B8354]/20 rounded-md transition-colors font-semibold"
                      >
                        تفاصيل
                      </button>
                      <select
                        value={ticket.status}
                        onChange={(e) => onStatusChange(ticket._id, e.target.value)}
                        className="text-xs px-2 py-1.5 border border-gray-200 rounded-md focus:outline-none focus:ring-2 focus:ring-[#1B8354]/20"
                      >
                        <option value="جديد">جديد</option>
                        <option value="قيد المعالجة">قيد المعالجة</option>
                        <option value="متأخر">متأخر</option>
                        <option value="منتهي">منتهي</option>
                      </select>
                      <button
                        onClick={() => onDelete(ticket._id)}
                        className="p-1.5 text-red-400 hover:text-red-600 hover:bg-red-50 rounded-md transition-colors"
                        title="حذف البلاغ"
                      >
                        <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={1.5}>
                          <path strokeLinecap="round" strokeLinejoin="round" d="m14.74 9-.346 9m-4.788 0L9.26 9m9.968-3.21c.342.052.682.107 1.022.166m-1.022-.165L18.16 19.673a2.25 2.25 0 0 1-2.244 2.077H8.084a2.25 2.25 0 0 1-2.244-2.077L4.772 5.79m14.456 0a48.108 48.108 0 0 0-3.478-.397m-12 .562c.34-.059.68-.114 1.022-.165m0 0a48.11 48.11 0 0 1 3.478-.397m7.5 0v-.916c0-1.18-.91-2.164-2.09-2.201a51.964 51.964 0 0 0-3.32 0c-1.18.037-2.09 1.022-2.09 2.201v.916m7.5 0a48.667 48.667 0 0 0-7.5 0" />
                        </svg>
                      </button>
                    </div>
                  </td>
                </tr>
              );
            })}
            {tickets.length === 0 && (
              <tr>
                <td colSpan={6} className="py-12 text-center text-gray-400">لا توجد بلاغات حالياً</td>
              </tr>
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
}

/* ── Detail Modal ── */
function DetailModal({ ticket, onClose }) {
  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 backdrop-blur-sm" onClick={onClose}>
      <div
        className="bg-white rounded-xl shadow-2xl max-w-lg w-full mx-4 max-h-[90vh] overflow-y-auto"
        onClick={(e) => e.stopPropagation()}
      >
        <div className="relative">
          {ticket.imageUrl ? (
            <img
              src={ticket.imageUrl}
              alt={ticket.title}
              className="w-full h-64 object-cover rounded-t-xl"
            />
          ) : (
            <div className="w-full h-48 bg-gray-100 rounded-t-xl flex items-center justify-center">
              <svg className="w-16 h-16 text-gray-300" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={1}>
                <path strokeLinecap="round" strokeLinejoin="round" d="m2.25 15.75 5.159-5.159a2.25 2.25 0 0 1 3.182 0l5.159 5.159m-1.5-1.5 1.409-1.409a2.25 2.25 0 0 1 3.182 0l2.909 2.909M3.75 21h16.5A2.25 2.25 0 0 0 22.5 18.75V5.25A2.25 2.25 0 0 0 20.25 3H3.75A2.25 2.25 0 0 0 1.5 5.25v13.5A2.25 2.25 0 0 0 3.75 21Z" />
              </svg>
            </div>
          )}
          <button
            onClick={onClose}
            className="absolute top-3 left-3 w-8 h-8 bg-black/40 hover:bg-black/60 text-white rounded-full flex items-center justify-center transition-colors"
          >
            <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
              <path strokeLinecap="round" strokeLinejoin="round" d="M6 18 18 6M6 6l12 12" />
            </svg>
          </button>
        </div>
        <div className="p-6 space-y-4 text-right">
          <h3 className="text-xl font-bold text-gray-900">{ticket.title}</h3>
          <p className="text-sm font-mono text-gray-400">{ticket.ticketId || ''}</p>
          <div className="flex items-center gap-2">
            <span className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-semibold bg-gray-100 text-gray-600">
              {ticket.category}
            </span>
            <span className={`inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-semibold ${(STATUS_CONFIG[ticket.status] || STATUS_CONFIG['جديد']).color}`}>
              <span className={`w-1.5 h-1.5 rounded-full ${(STATUS_CONFIG[ticket.status] || STATUS_CONFIG['جديد']).dot}`} />
              {ticket.status}
            </span>
          </div>
          <div className="pt-3 border-t border-gray-100">
            <p className="text-sm text-gray-700 leading-relaxed whitespace-pre-wrap">
              {ticket.description || 'لا توجد تفاصيل إضافية لهذا البلاغ.'}
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}
