import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import '../models/models.dart';

/// Orders tab — placeholder list of (hard-coded) past/upcoming orders.
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ac = SampleData.serviceById('ac-clean-1');
    final clean = SampleData.serviceById('clean-regular-1');

    return Scaffold(
      appBar: AppBar(title: const Text('Pesanan Saya')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            _OrderCard(
              service: ac,
              status: 'Menunggu teknisi',
              statusColor: const Color(0xFFF59E0B),
              schedule: 'Hari ini • 13:00',
            ),
            const SizedBox(height: 14),
            _OrderCard(
              service: clean,
              status: 'Selesai',
              statusColor: const Color(0xFF16A34A),
              schedule: '12 Okt • 09:30',
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({
    required this.service,
    required this.status,
    required this.statusColor,
    required this.schedule,
  });

  final ServiceItem service;
  final String status;
  final Color statusColor;
  final String schedule;

  @override
  Widget build(BuildContext context) {
    final category = SampleData.categoryById(service.categoryId);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE6EBF5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                child: Text(service.name,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700)),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(status,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: statusColor)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.event_rounded,
                      size: 16, color: Color(0xFF94A3B8)),
                  const SizedBox(width: 6),
                  Text(schedule,
                      style: const TextStyle(
                          fontSize: 13, color: Color(0xFF64748B))),
                ],
              ),
              Text(formatIdr(service.price),
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2563EB))),
            ],
          ),
        ],
      ),
    );
  }
}
