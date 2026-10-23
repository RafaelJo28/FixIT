import 'package:flutter/material.dart';

import '../theme.dart';
import 'phone_screen.dart';
import 'user_role.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _open(BuildContext context, UserRole role) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => PhoneScreen(role: role)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.blue,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.handyman_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'FixIT',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              const Text(
                'Selamat datang!',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Pilih cara kamu menggunakan FixIT.',
                style: TextStyle(fontSize: 15, color: AppColors.body),
              ),
              const SizedBox(height: 28),
              _RoleCard(
                icon: Icons.home_repair_service_rounded,
                color: AppColors.blue,
                title: 'Saya butuh tukang',
                subtitle: 'Pesan servis AC, listrik, pipa, dan lainnya dengan harga yang jelas.',
                onTap: () => _open(context, UserRole.customer),
              ),
              const SizedBox(height: 14),
              _RoleCard(
                icon: Icons.handyman_rounded,
                color: const Color(0xFF0369A1),
                title: 'Saya tukang / mitra',
                subtitle:
                    'Terima pekerjaan di sekitarmu dan atur jadwalmu sendiri.',
                onTap: () => _open(context, UserRole.vendor),
              ),
              const SizedBox(height: 32),
              const Text(
                'Dengan melanjutkan, kamu menyetujui Syarat & Ketentuan dan Kebijakan Privasi FixIT.',
                style: TextStyle(
                  fontSize: 12,
                  height: 1.4,
                  color: AppColors.muted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.line),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(icon, color: color, size: 30),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.35,
                        color: AppColors.body,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
            ],
          ),
        ),
      ),
    );
  }
}
