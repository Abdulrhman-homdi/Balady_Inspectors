import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/ticket_model.dart';
import '../services/api_service.dart';

class ProcessTicketScreen extends StatefulWidget {
  final Ticket ticket;
  final bool isGuest;
  const ProcessTicketScreen({super.key, required this.ticket, this.isGuest = false});
  @override
  State<ProcessTicketScreen> createState() => _ProcessTicketScreenState();
}

class _ProcessTicketScreenState extends State<ProcessTicketScreen> {
  int _currentStep = 0;
  bool _loading = false;

  static const _labels = [
    'مراجعة بيانات النظام',
    'التواصل مع الجهة المسؤولة',
    'التوجه إلى مكان البلاغ',
    'تصوير وتأكيد البلاغ',
    'تحرير الضبط والتوقيع',
    'رفع التقرير والإنهاء',
  ];

  void _next() {
    if (_currentStep < _labels.length - 1) {
      setState(() => _currentStep++);
    } else {
      _finish();
    }
  }

  void _back() {
    if (_currentStep > 0) setState(() => _currentStep--);
  }

  Future<void> _finish() async {
    setState(() => _loading = true);
    try {
      await ApiService.performAction(
        id: widget.ticket.id,
        action: 'مباشرة',
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ تم مباشرة البلاغ بنجاح')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ فشل مباشرة البلاغ: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'مباشرة البلاغ',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            fontFamily: 'IBMPlexSansArabic',
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_forward_ios, color: Theme.of(context).colorScheme.onSurface, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            _progressIndicator(context, _currentStep),
            Expanded(child: _stepContent(context, _currentStep, widget.ticket)),
            _bottomNav(context, _currentStep, _labels.length, _loading, _next, _back),
          ],
        ),
      ),
    );
  }
}

Widget _progressIndicator(BuildContext context, int currentStep) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
    color: Theme.of(context).cardColor,
    child: Column(
      children: [
        SizedBox(
          height: 4,
          child: Row(
            children: List.generate(_ProcessTicketScreenState._labels.length, (i) {
              final isActive = i <= currentStep;
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: isActive
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 20,
          child: Row(
            children: List.generate(_ProcessTicketScreenState._labels.length, (i) {
              final isCurrent = i == currentStep;
              return Expanded(
                child: Text(
                  _ProcessTicketScreenState._labels[i],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 9,
                    fontFamily: 'IBMPlexSansArabic',
                    fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                    color: isCurrent
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }),
          ),
        ),
      ],
    ),
  );
}

Widget _stepContent(BuildContext context, int step, Ticket ticket) {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text('${step + 1}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _ProcessTicketScreenState._labels[step],
                style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w700,
                  fontFamily: 'IBMPlexSansArabic',
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _stepBody(context, step, ticket),
      ],
    ),
  );
}

Widget _stepBody(BuildContext context, int step, Ticket ticket) {
  switch (step) {
    case 0: return _StepReview(context: context, ticket: ticket);
    case 1: return _StepContact();
    case 2: return _StepNavigate(context: context, ticket: ticket);
    case 3: return _StepPhoto(context: context);
    case 4: return _StepReport(context: context);
    case 5: return _StepUpload(context: context, ticket: ticket);
    default: return const SizedBox();
  }
}

Widget _bottomNav(BuildContext context, int step, int total, bool loading, VoidCallback next, VoidCallback back) {
  return Container(
    padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
    decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
          blurRadius: 8, offset: const Offset(0, -4),
        ),
      ],
    ),
    child: SafeArea(
      top: false,
      child: Row(
        children: [
          if (step > 0)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: loading ? null : back,
                icon: const Icon(Icons.arrow_back, size: 18),
                label: const Text('رجوع', style: TextStyle(fontFamily: 'IBMPlexSansArabic')),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          if (step > 0) const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: loading ? null : next,
              icon: loading
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Icon(step < total - 1 ? Icons.arrow_forward : Icons.check_circle, size: 18),
              label: Text(
                step < total - 1 ? 'التالي' : 'إنهاء',
                style: const TextStyle(fontFamily: 'IBMPlexSansArabic'),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

// ─── Step 0 ───
class _StepReview extends StatelessWidget {
  final BuildContext context;
  final Ticket ticket;
  const _StepReview({required this.context, required this.ticket});

  @override
  Widget build(BuildContext c) {
    final loc = ticket.location;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _sectionTitle(context, 'معلومات البلاغ'),
        const SizedBox(height: 12),
        _infoCard(context, [
          _row(context, 'رقم البلاغ', ticket.ticketId),
          _row(context, 'العنوان', ticket.title),
          _row(context, 'التصنيف', ticket.category),
          _row(context, 'الحالة', ticket.status),
        ]),
        if (ticket.imageUrl.isNotEmpty) ...[
          const SizedBox(height: 16),
          _sectionTitle(context, 'الصورة المرفقة'),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(ticket.imageUrl, height: 200, width: double.infinity, fit: BoxFit.cover),
          ),
        ],
        if (ticket.description.isNotEmpty) ...[
          const SizedBox(height: 16),
          _sectionTitle(context, 'الوصف'),
          const SizedBox(height: 8),
          Container(
            width: double.infinity, padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Theme.of(context).shadowColor.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: Text(ticket.description, style: const TextStyle(fontSize: 14, height: 1.6)),
          ),
        ],
        if (loc != null) ...[
          const SizedBox(height: 16),
          _sectionTitle(context, 'موقع البلاغ'),
          const SizedBox(height: 8),
          _infoCard(context, [
            if (loc.address.isNotEmpty) _row(context, 'العنوان', loc.address),
            if (loc.district.isNotEmpty) _row(context, 'الحي', loc.district),
            if (loc.landmark.isNotEmpty) _row(context, 'معلم قريب', loc.landmark),
            if (loc.lat != 0) _row(context, 'الإحداثيات', '${loc.lat}, ${loc.lng}'),
          ]),
        ],
      ],
    );
  }
}

// ─── Step 1 ───
class _StepContact extends StatefulWidget {
  @override
  State<_StepContact> createState() => _StepContactState();
}

class _StepContactState extends State<_StepContact> {
  final _entityController = TextEditingController();
  final _noteController = TextEditingController();
  bool _contacted = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _sectionTitle(context, 'بيانات التواصل'),
        const SizedBox(height: 12),
        Container(
          width: double.infinity, padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Theme.of(context).shadowColor.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('الجهة المسؤولة', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(controller: _entityController, decoration: const InputDecoration(hintText: 'اسم الجهة', border: OutlineInputBorder())),
              const SizedBox(height: 16),
              const Text('ملاحظات التواصل', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(controller: _noteController, maxLines: 3, decoration: const InputDecoration(hintText: 'ملاحظات...', border: OutlineInputBorder())),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('تم التواصل', style: TextStyle(fontSize: 14, fontFamily: 'IBMPlexSansArabic')),
                value: _contacted, onChanged: (v) => setState(() => _contacted = v),
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() { _entityController.dispose(); _noteController.dispose(); super.dispose(); }
}

// ─── Step 2 ───
class _StepNavigate extends StatelessWidget {
  final BuildContext context;
  final Ticket ticket;
  const _StepNavigate({required this.context, required this.ticket});

  @override
  Widget build(BuildContext c) {
    final loc = ticket.location;
    final hasCoords = loc != null && loc.lat != 0 && loc.lng != 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _sectionTitle(context, 'التوجه إلى موقع البلاغ'),
        const SizedBox(height: 12),
        if (hasCoords) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 250,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(loc.lat, loc.lng), initialZoom: 16,
                ),
                children: [
                  TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', userAgentPackageName: 'com.balady.app'),
                  MarkerLayer(markers: [
                    Marker(point: LatLng(loc.lat, loc.lng), width: 40, height: 40, child: const Icon(Icons.location_on, color: Colors.red, size: 36)),
                  ]),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity, padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Theme.of(context).shadowColor.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (loc.address.isNotEmpty) _row(context, 'العنوان', loc.address),
                if (loc.district.isNotEmpty) _row(context, 'الحي', loc.district),
                if (loc.landmark.isNotEmpty) _row(context, 'معلم قريب', loc.landmark),
                _row(context, 'الإحداثيات', '${loc.lat}, ${loc.lng}'),
              ],
            ),
          ),
        ] else
          Container(
            height: 120,
            decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(12)),
            child: Center(child: Text('لا توجد إحداثيات للموقع',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5)))),
          ),
      ],
    );
  }
}

// ─── Step 3 ───
class _StepPhoto extends StatelessWidget {
  final BuildContext context;
  const _StepPhoto({required this.context});

  @override
  Widget build(BuildContext c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _sectionTitle(context, 'تصوير البلاغ'),
        const SizedBox(height: 12),
        Container(
          width: double.infinity, padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).dividerColor, width: 2, style: BorderStyle.solid),
          ),
          child: Column(
            children: [
              Icon(Icons.camera_alt, size: 64, color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5)),
              const SizedBox(height: 12),
              Text('التقط صورة لتأكيد البلاغ',
                style: TextStyle(fontSize: 14, fontFamily: 'IBMPlexSansArabic', color: Theme.of(context).colorScheme.onSurfaceVariant)),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.camera_alt, size: 18),
                label: const Text('فتح الكاميرا', style: TextStyle(fontFamily: 'IBMPlexSansArabic')),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _sectionTitle(context, 'تأكيد البلاغ'),
        const SizedBox(height: 8),
        Container(
          width: double.infinity, padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('ملاحظات التصوير', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(maxLines: 3, decoration: const InputDecoration(hintText: 'أضف ملاحظات...', border: OutlineInputBorder())),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Step 4 ───
class _StepReport extends StatelessWidget {
  final BuildContext context;
  const _StepReport({required this.context});

  @override
  Widget build(BuildContext c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _sectionTitle(context, 'تحرير الضبط'),
        const SizedBox(height: 12),
        Container(
          width: double.infinity, padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('محتوى الضبط', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(maxLines: 8, decoration: const InputDecoration(hintText: 'اكتب محتوى الضبط هنا...', border: OutlineInputBorder())),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _sectionTitle(context, 'التوقيع'),
        const SizedBox(height: 8),
        Container(
          width: double.infinity, height: 150,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.draw, size: 48, color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.3)),
                const SizedBox(height: 8),
                Text('مكان التوقيع',
                  style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5))),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Step 5 ───
class _StepUpload extends StatelessWidget {
  final BuildContext context;
  final Ticket ticket;
  const _StepUpload({required this.context, required this.ticket});

  @override
  Widget build(BuildContext c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _sectionTitle(context, 'ملخص مباشرة البلاغ'),
        const SizedBox(height: 12),
        Container(
          width: double.infinity, padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _row(context, 'رقم البلاغ', ticket.ticketId),
              _row(context, 'العنوان', ticket.title),
              _row(context, 'التصنيف', ticket.category),
              const Divider(height: 24),
              const Text('تم إتمام جميع الخطوات بنجاح. سيتم تغيير حالة البلاغ إلى "قيد المعالجة" بعد تأكيد مباشرة البلاغ.',
                style: TextStyle(fontSize: 13, height: 1.6), textAlign: TextAlign.right),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _sectionTitle(context, 'رفع التقرير'),
        const SizedBox(height: 8),
        Container(
          width: double.infinity, padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: Column(
            children: [
              Icon(Icons.upload_file, size: 48, color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5)),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.attach_file, size: 18),
                label: const Text('رفع التقرير', style: TextStyle(fontFamily: 'IBMPlexSansArabic')),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Shared helpers ───
Widget _sectionTitle(BuildContext context, String text) {
  return Text(text, style: TextStyle(
    fontSize: 15, fontWeight: FontWeight.w700, fontFamily: 'IBMPlexSansArabic',
    color: Theme.of(context).colorScheme.onSurface,
  ));
}

Widget _row(BuildContext context, String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: [
        Expanded(child: Text(value, textDirection: TextDirection.ltr, style: const TextStyle(fontSize: 14))),
        const SizedBox(width: 8),
        Text('$label: ', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurfaceVariant)),
      ],
    ),
  );
}

Widget _infoCard(BuildContext context, List<Widget> children) {
  return Container(
    width: double.infinity, padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(12),
      boxShadow: [BoxShadow(color: Theme.of(context).shadowColor.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, 2))],
    ),
    child: Column(children: children),
  );
}
