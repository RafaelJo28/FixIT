import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import '../models/models.dart';
import 'checkout_screen.dart';

/// Step 1 of booking: pick a date, time slot, and address, then continue.
class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key, required this.item});

  final ServiceItem item;

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int _dayIndex = 0;
  int? _slotIndex;
  String _address = 'Jl. Margonda Raya No. 123, Depok';

  late final List<_Day> _days = _buildDays();

  static List<_Day> _buildDays() {
    const names = ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'];
    final now = DateTime.now();
    return List.generate(7, (i) {
      final d = now.add(Duration(days: i));
      return _Day(
        label: names[d.weekday % 7],
        date: d.day,
        month: _monthNames[d.month - 1],
        full:
            '${names[d.weekday % 7]}, ${d.day} ${_monthNames[d.month - 1]} ${d.year}',
      );
    });
  }

  static const _monthNames = [
    'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
    'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
  ];

  bool get _canContinue => _slotIndex != null;

  @override
  Widget build(BuildContext context) {
    final slot = _slotIndex != null ? SampleData.timeSlots[_slotIndex!] : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Atur Jadwal')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          children: [
            _serviceSummary(),
            const SizedBox(height: 20),
            const _StepLabel('Pilih hari'),
            const SizedBox(height: 10),
            _dayPicker(),
            const SizedBox(height: 20),
            const _StepLabel('Pilih jam'),
            const SizedBox(height: 10),
            _slotPicker(),
            const SizedBox(height: 20),
            const _StepLabel('Alamat pekerjaan'),
            const SizedBox(height: 10),
            _addressField(),
          ],
        ),
      ),
      bottomNavigationBar: _bottomBar(slot?.label),
    );
  }

  Widget _serviceSummary() {
    final category = SampleData.categoryById(widget.item.categoryId);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE6EBF5)),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: category.color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(category.icon, color: category.color, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text('${widget.item.durationMinutes} menit',
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF94A3B8))),
              ],
            ),
          ),
          Text(formatIdr(widget.item.price),
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2563EB))),
        ],
      ),
    );
  }

  Widget _dayPicker() {
    return SizedBox(
      height: 78,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _days.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final d = _days[i];
          final selected = i == _dayIndex;
          return InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => setState(() => _dayIndex = i),
            child: Container(
              width: 62,
              decoration: BoxDecoration(
                color: selected ? const Color(0xFF2563EB) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: selected
                      ? const Color(0xFF2563EB)
                      : const Color(0xFFE6EBF5),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(d.label,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: selected
                              ? Colors.white70
                              : const Color(0xFF94A3B8))),
                  const SizedBox(height: 4),
                  Text('${d.date}',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: selected
                              ? Colors.white
                              : const Color(0xFF0F172A))),
                  Text(d.month,
                      style: TextStyle(
                          fontSize: 11,
                          color: selected
                              ? Colors.white70
                              : const Color(0xFF94A3B8))),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _slotPicker() {
    final slots = SampleData.timeSlots;
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: List.generate(slots.length, (i) {
        final s = slots[i];
        final selected = i == _slotIndex;
        final disabled = !s.enabled;
        return InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: disabled
              ? null
              : () => setState(() => _slotIndex = selected ? null : i),
          child: Opacity(
            opacity: disabled ? 0.4 : 1,
            child: Container(
              width: 92,
              padding: const EdgeInsets.symmetric(vertical: 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? const Color(0xFF2563EB) : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: selected
                      ? const Color(0xFF2563EB)
                      : const Color(0xFFE6EBF5),
                ),
              ),
              child: Text(s.label,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: selected
                          ? Colors.white
                          : const Color(0xFF0F172A))),
            ),
          ),
        );
      }),
    );
  }

  Widget _addressField() {
    return TextField(
      maxLines: 2,
      controller: TextEditingController(text: _address),
      onChanged: (v) => _address = v,
      decoration: const InputDecoration(
        hintText: 'Masukkan alamat lengkap',
        prefixIcon: Icon(Icons.location_on_outlined, color: Color(0xFF94A3B8)),
      ),
    );
  }

  Widget _bottomBar(String? slotLabel) {
    final day = _days[_dayIndex].full;
    final ready = _canContinue;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE6EBF5))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (ready)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  const Icon(Icons.event_rounded,
                      size: 16, color: Color(0xFF2563EB)),
                  const SizedBox(width: 6),
                  Text('$day • $slotLabel',
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF475569))),
                ],
              ),
            ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: ready
                  ? () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => CheckoutScreen(
                            item: widget.item,
                            schedule: '$day • $slotLabel',
                            address: _address,
                          ),
                        ),
                      )
                  : null,
              child: Text(ready ? 'Lanjut ke Pembayaran' : 'Pilih jam dulu'),
            ),
          ),
        ],
      ),
    );
  }
}

class _Day {


  const _Day({
    required this.label,
    required this.date,
    required this.month,
    required this.full,
  });

  final String label;
  final int date;
  final String month;
  final String full;
}

class _StepLabel extends StatelessWidget {
  const _StepLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700));
  }
}
