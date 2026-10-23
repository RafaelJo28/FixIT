import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/common.dart';
import 'vendor_models.dart';
import 'vendor_store.dart';

class VendorJobDetailScreen extends StatelessWidget {
  const VendorJobDetailScreen({super.key, required this.job});

  final Job job;

  @override
  Widget build(BuildContext context) {
    final store = VendorStore.instance;

    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final s = job.status;
        final isNew = s == JobStatus.newRequest;

        return Scaffold(
          appBar: AppBar(title: const Text('Detail Pekerjaan')),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: cardDecoration(),
                  child: Row(
                    children: [
                      IconBadge(icon: job.icon, color: job.color, size: 52),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              job.serviceName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              job.categoryLabel,
                              style: const TextStyle(
                                fontSize: 12.5,
                                color: AppColors.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      StatusChip(label: s.label, color: s.color),
                    ],
                  ),
                ),

                if (s.step >= 0) ...[
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 14,
                    ),
                    decoration: cardDecoration(),
                    child: _StepperRow(step: s.step),
                  ),
                ],
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: cardDecoration(),
                  child: Column(
                    children: [
                      _InfoRow(
                        icon: Icons.schedule_rounded,
                        label: 'Jadwal',
                        value: job.schedule,
                      ),
                      const SizedBox(height: 12),
                      _InfoRow(
                        icon: Icons.person_outline_rounded,
                        label: 'Pelanggan',
                        value: job.customerName,
                      ),
                      const SizedBox(height: 12),
                      _InfoRow(
                        icon: Icons.location_on_outlined,
                        label: 'Lokasi',
                        value: isNew
                            ? '${job.area} (${job.distanceKm.toStringAsFixed(1)} km)'
                            : job.fullAddress,
                      ),
                      if (isNew) ...[
                        const SizedBox(height: 10),
                        const Text(
                          'Alamat lengkap muncul setelah kamu menerima pekerjaan.',
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.4,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SectionTitle('Keluhan pelanggan'),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: cardDecoration(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.note,
                        style: const TextStyle(
                          fontSize: 13.5,
                          height: 1.45,
                          color: AppColors.body,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          for (var i = 0; i < 2; i++)
                            Container(
                              width: 72,
                              height: 72,
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE2E8F0),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.image_outlined,
                                color: AppColors.muted,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SectionTitle('Rincian pendapatan'),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: cardDecoration(),
                  child: Column(
                    children: [
                      _MoneyRow(
                        label: 'Harga layanan',
                        value: rupiah(job.price),
                      ),
                      const SizedBox(height: 8),
                      _MoneyRow(
                        label:
                            'Komisi platform (${(kCommissionRate * 100).round()}%)',
                        value: rupiah(-job.commission),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Divider(height: 1),
                      ),
                      _MoneyRow(
                        label: 'Pendapatan bersih',
                        value: rupiah(job.net),
                        bold: true,
                        color: AppColors.success,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: _ActionBar(job: job),
        );
      },
    );
  }
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({required this.job});

  final Job job;

  @override
  Widget build(BuildContext context) {
    final store = VendorStore.instance;
    final s = job.status;
    final action = s.actionLabel;

    Widget content;
    if (s == JobStatus.newRequest) {
      content = Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                store.decline(job);
                Navigator.of(context).pop();
              },
              child: const Text('Tolak'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () => store.accept(job),
              child: const Text('Terima pekerjaan'),
            ),
          ),
        ],
      );
    } else if (action != null) {
      content = Row(
        children: [
          OutlinedButton(
            onPressed: () => comingSoon(context, 'Chat pelanggan'),
            child: const Icon(Icons.chat_bubble_outline_rounded),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () => store.advance(job),
              child: Text(action),
            ),
          ),
        ],
      );
    } else {
      content = const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_rounded, color: AppColors.success),
          SizedBox(width: 8),
          Flexible(
            child: Text(
              'Pekerjaan selesai. Pendapatan masuk ke saldo.',
              style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: SafeArea(top: false, child: content),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.blue),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: AppColors.muted),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MoneyRow extends StatelessWidget {
  const _MoneyRow({
    required this.label,
    required this.value,
    this.bold = false,
    this.color,
  });

  final String label;
  final String value;
  final bool bold;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final weight = bold ? FontWeight.w800 : FontWeight.w600;
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: weight,
              color: bold ? AppColors.ink : AppColors.body,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 14, fontWeight: weight, color: color),
        ),
      ],
    );
  }
}

class _StepperRow extends StatelessWidget {
  const _StepperRow({required this.step});

  final int step;

  static const _labels = ['Diterima', 'Perjalanan', 'Dikerjakan', 'Selesai'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < _labels.length; i++)
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 3,
                        color: i == 0
                            ? Colors.transparent
                            : (i <= step ? AppColors.blue : AppColors.line),
                      ),
                    ),
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i <= step ? AppColors.blue : Colors.white,
                        border: Border.all(
                          color: i <= step ? AppColors.blue : AppColors.line,
                          width: 1.5,
                        ),
                      ),
                      child: i <= step
                          ? const Icon(
                              Icons.check_rounded,
                              size: 14,
                              color: Colors.white,
                            )
                          : null,
                    ),
                    Expanded(
                      child: Container(
                        height: 3,
                        color: i == _labels.length - 1
                            ? Colors.transparent
                            : (i < step ? AppColors.blue : AppColors.line),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  _labels[i],
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: i <= step ? AppColors.ink : AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
