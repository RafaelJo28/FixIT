import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import '../models/models.dart';
import 'root_shell.dart';

/// Confirmation screen shown after a successful (simulated) payment.
class SuccessScreen extends StatelessWidget {
  const SuccessScreen({
    super.key,
    required this.item,
    required this.schedule,
    required this.paymentMethod,
    required this.total,
  });

  final ServiceItem item;
  final String schedule;
  final String paymentMethod;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 96,
                height: 96,
                decoration: const BoxDecoration(
                  color: Color(0xFF2563EB),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded,
                    color: Colors.white, size: 56),
              ),
              const SizedBox(height: 24),
              const Text('Pemesanan Berhasil!',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5)),
              const SizedBox(height: 8),
              const Text(
                'Teknisi akan segera dikonfirmasi. Kami kirim update lewat WhatsApp.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, height: 1.5, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 28),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE6EBF5)),
                ),
                child: Column(
                  children: [
                    _detailRow('Layanan', item.name),
                    const SizedBox(height: 12),
                    _detailRow('Jadwal', schedule),
                    const SizedBox(height: 12),
                    _detailRow('Bayar via', paymentMethod),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(height: 1),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total dibayar',
                            style: TextStyle(
                                fontSize: 14, color: Color(0xFF64748B))),
                        Text(formatIdr(total),
                            style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF2563EB))),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const RootShell()),
                    (route) => false,
                  ),
                  child: const Text('Kembali ke Beranda'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(label,
              style:
                  const TextStyle(fontSize: 13, color: Color(0xFF94A3B8))),
        ),
        Expanded(
          child: Text(value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F172A))),
        ),
      ],
    );
  }
}
