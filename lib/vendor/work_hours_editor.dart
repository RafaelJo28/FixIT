import 'package:flutter/material.dart';

import '../data/worker_directory.dart';
import '../models/worker_profile.dart';
import '../theme.dart';
import '../widgets/common.dart';

/// Editor for the seven opening-hour rows. Used in the registration form and
/// on the vendor profile.
class WorkHoursEditor extends StatelessWidget {
  const WorkHoursEditor({super.key, required this.hours, required this.onChanged});

  final List<DayHours> hours;
  final ValueChanged<List<DayHours>> onChanged;

  void _set(int i, DayHours h) {
    final next = List<DayHours>.of(hours);
    next[i] = h;
    onChanged(next);
  }

  Future<void> _pick(BuildContext context, int i, {required bool opening}) async {
    final d = hours[i];
    final initial = (opening ? d.openMin : d.closeMin) ?? (opening ? 8 * 60 : 17 * 60);
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: initial ~/ 60, minute: initial % 60),
      builder: (ctx, child) => MediaQuery(
        data: MediaQuery.of(ctx).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    if (t == null) return;
    final m = t.hour * 60 + t.minute;
    _set(i, opening ? DayHours(m, d.closeMin) : DayHours(d.openMin, m));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < hours.length; i++)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.fromLTRB(6, 4, 12, 4),
            decoration: cardDecoration(radius: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Switch(
                      value: hours[i].isOpen,
                      onChanged: (on) => _set(
                        i,
                        on ? const DayHours(8 * 60, 17 * 60) : const DayHours.closed(),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        kDayNames[i],
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                    ),
                    if (hours[i].isOpen) ...[
                      _TimeButton(
                        label: formatMinutes(hours[i].openMin!),
                        onTap: () => _pick(context, i, opening: true),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        child: Text('-'),
                      ),
                      _TimeButton(
                        label: formatMinutes(hours[i].closeMin!),
                        onTap: () => _pick(context, i, opening: false),
                      ),
                    ] else
                      const Text(
                        'Libur',
                        style: TextStyle(fontSize: 13.5, color: AppColors.muted),
                      ),
                  ],
                ),
                if (!hours[i].isValid)
                  const Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 8),
                    child: Text(
                      'Jam tutup harus setelah jam buka.',
                      style: TextStyle(fontSize: 12, color: AppColors.danger),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class _TimeButton extends StatelessWidget {
  const _TimeButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        minimumSize: const Size(0, 36),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(label),
    );
  }
}

/// Full-screen version for the vendor profile ("Ubah" next to Jam kerja).
class WorkHoursScreen extends StatefulWidget {
  const WorkHoursScreen({super.key});

  @override
  State<WorkHoursScreen> createState() => _WorkHoursScreenState();
}

class _WorkHoursScreenState extends State<WorkHoursScreen> {
  late List<DayHours> _hours = List<DayHours>.of(WorkerDirectory.instance.me.workHours);

  void _save() {
    WorkerDirectory.instance.updateMe((m) => m.workHours = _hours);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jam kerja')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        children: [
          const Text(
            'Pelanggan melihat jam kerjamu di profil dan hanya bisa memesan di jam ini.',
            style: TextStyle(fontSize: 13.5, height: 1.4, color: AppColors.body),
          ),
          const SizedBox(height: 16),
          WorkHoursEditor(
            hours: _hours,
            onChanged: (h) => setState(() => _hours = h),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.line)),
        ),
        child: SafeArea(
          top: false,
          child: ElevatedButton(
            onPressed: validWorkHours(_hours) ? _save : null,
            child: const Text('Simpan'),
          ),
        ),
      ),
    );
  }
}
