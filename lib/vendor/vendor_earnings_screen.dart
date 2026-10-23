import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/common.dart';
import 'vendor_models.dart';
import 'vendor_store.dart';

const _green = AppColors.success;

class VendorEarningsScreen extends StatelessWidget {
  const VendorEarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = VendorStore.instance;

    return Scaffold(
      appBar: AppBar(title: const Text('Pendapatan')),
      body: ListenableBuilder(
        listenable: store,
        builder: (context, _) {
          final weekTotal = store.weekEarnings.fold<int>(0, (a, b) => a + b);

          return ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              _BalanceCard(balance: store.balance),
              const SectionTitle('Minggu ini'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: cardDecoration(),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Total minggu ini',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.muted,
                              ),
                            ),
                          ),
                          Text(
                            rupiah(weekTotal),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _WeekBars(values: store.weekEarnings),
                    ],
                  ),
                ),
              ),
              const SectionTitle('Riwayat'),
              for (final e in store.history) _HistoryTile(entry: e),
            ],
          );
        },
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.balance});

  final int balance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(
            colors: [Color(0xFF1E3A8A), AppColors.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Saldo tersedia',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.88),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 6),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                rupiah(balance),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.blue,
              ),
              onPressed: () => comingSoon(context, 'Penarikan saldo'),
              child: const Text('Tarik saldo'),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeekBars extends StatelessWidget {
  const _WeekBars({required this.values});

  final List<int> values;

  static const _days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

  @override
  Widget build(BuildContext context) {
    final maxValue = values.fold<int>(1, (m, v) => v > m ? v : m);
    final today = DateTime.now().weekday - 1;

    return SizedBox(
      height: 156,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < values.length; i++)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    values[i] == 0 ? '' : '${(values[i] / 1000).round()}k',
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: AppColors.muted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    height: values[i] == 0 ? 4 : 100 * values[i] / maxValue,
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      color: i == today
                          ? AppColors.blue
                          : AppColors.blue.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _days[i],
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: i == today ? AppColors.ink : AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.entry});

  final EarningEntry entry;

  @override
  Widget build(BuildContext context) {
    final income = entry.amount >= 0;
    final color = income ? _green : AppColors.ink;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: cardDecoration(radius: 16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: color.withValues(alpha: 0.10),
              child: Icon(
                income ? Icons.south_west_rounded : Icons.north_east_rounded,
                size: 18,
                color: color,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    entry.date,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              income ? '+${rupiah(entry.amount)}' : rupiah(entry.amount),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
