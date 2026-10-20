import 'package:flutter/material.dart';

import '../data/sample_data.dart';

/// Profile tab — static prototype menu.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _toast(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label — menyusul (prototype)'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF0F172A),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            _profileHeader(),
            const SizedBox(height: 24),
            _MenuGroup(
              title: 'Akun',
              items: const [
                _MenuItem(Icons.person_outline_rounded, 'Data diri'),
                _MenuItem(Icons.location_on_outlined, 'Alamat tersimpan'),
                _MenuItem(Icons.account_balance_wallet_outlined,
                    'Metode pembayaran'),
              ],
              onTap: _toast,
            ),
            const SizedBox(height: 16),
            _MenuGroup(
              title: 'Lainnya',
              items: const [
                _MenuItem(Icons.help_outline_rounded, 'Bantuan'),
                _MenuItem(Icons.description_outlined, 'Syarat & ketentuan'),
                _MenuItem(Icons.logout_rounded, 'Keluar'),
              ],
              onTap: _toast,
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileHeader() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child:
                const Icon(Icons.person_rounded, color: Colors.white, size: 34),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Joel Pratama',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text('+62 812-3456-7890',
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 13)),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(SampleData.city,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem {
  const _MenuItem(this.icon, this.label);

  final IconData icon;
  final String label;
}

class _MenuGroup extends StatelessWidget {
  const _MenuGroup({
    required this.title,
    required this.items,
    required this.onTap,
  });

  final String title;
  final List<_MenuItem> items;
  final void Function(BuildContext, String) onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE6EBF5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 4),
            child: Text(title,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF94A3B8))),
          ),
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) const Divider(indent: 18, endIndent: 18, height: 1),
            InkWell(
              onTap: () => onTap(context, items[i].label),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
                child: Row(
                  children: [
                    Icon(items[i].icon,
                        size: 22, color: const Color(0xFF2563EB)),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(items[i].label,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600)),
                    ),
                    const Icon(Icons.chevron_right_rounded,
                        color: Color(0xFF94A3B8)),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

