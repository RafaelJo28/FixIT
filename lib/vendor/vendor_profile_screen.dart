import 'package:flutter/material.dart';

import '../auth/welcome_screen.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'vendor_store.dart';

const _green = AppColors.success;
const _amber = Color(0xFFB45309);

class VendorProfileScreen extends StatelessWidget {
  const VendorProfileScreen({super.key});

  static const _skills = ['Servis AC', 'Listrik'];
  static const _areas = ['Depok', 'Bekasi'];

  Future<void> _logout(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Keluar dari akun?'),
        content: const Text('Kamu perlu masuk lagi untuk menerima pekerjaan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = VendorStore.instance;

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: ListenableBuilder(
        listenable: store,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: cardDecoration(radius: 20),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: AppColors.blue,
                      child: Text(
                        'H',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Hendra Saputra',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            '+62 812-3456-7890',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.muted,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                size: 16,
                                color: AppColors.star,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '${store.rating.toStringAsFixed(1)} | ${store.totalJobs} pekerjaan',
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SectionTitle('Keahlian'),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [for (final s in _skills) _Pill(label: s)],
              ),
              const SectionTitle('Wilayah layanan'),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final a in _areas) _Pill(label: a, icon: Icons.place),
                ],
              ),
              const SectionTitle('Verifikasi akun'),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: cardDecoration(),
                child: const Column(
                  children: [
                    _VerifyRow(
                      label: 'Foto KTP',
                      status: 'Terverifikasi',
                      done: true,
                    ),
                    SizedBox(height: 12),
                    _VerifyRow(
                      label: 'Foto selfie dengan KTP',
                      status: 'Terverifikasi',
                      done: true,
                    ),
                    SizedBox(height: 12),
                    _VerifyRow(
                      label: 'Sertifikat keahlian',
                      status: 'Menunggu',
                      done: false,
                    ),
                    SizedBox(height: 12),
                    _VerifyRow(
                      label: 'Rekening bank',
                      status: 'Terverifikasi',
                      done: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: cardDecoration(),
                child: Column(
                  children: [
                    _MenuRow(
                      icon: Icons.account_balance_outlined,
                      label: 'Rekening bank',
                      onTap: () => comingSoon(context, 'Rekening bank'),
                    ),
                    const Divider(height: 1),
                    _MenuRow(
                      icon: Icons.access_time_rounded,
                      label: 'Jam kerja',
                      onTap: () => comingSoon(context, 'Jam kerja'),
                    ),
                    const Divider(height: 1),
                    _MenuRow(
                      icon: Icons.help_outline_rounded,
                      label: 'Bantuan',
                      onTap: () => comingSoon(context, 'Bantuan'),
                    ),
                    const Divider(height: 1),
                    _MenuRow(
                      icon: Icons.logout_rounded,
                      label: 'Keluar',
                      color: AppColors.danger,
                      onTap: () => _logout(context),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, this.icon});

  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.blue.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: AppColors.blue),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.blue,
            ),
          ),
        ],
      ),
    );
  }
}

class _VerifyRow extends StatelessWidget {
  const _VerifyRow({
    required this.label,
    required this.status,
    required this.done,
  });

  final String label;
  final String status;
  final bool done;

  @override
  Widget build(BuildContext context) {
    final color = done ? _green : _amber;
    return Row(
      children: [
        Icon(
          done ? Icons.check_circle_rounded : Icons.hourglass_bottom_rounded,
          size: 20,
          color: color,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
        StatusChip(label: status, color: color),
      ],
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.ink;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 22, color: c),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  color: c,
                ),
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
          ],
        ),
      ),
    );
  }
}
