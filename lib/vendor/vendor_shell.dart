import 'package:flutter/material.dart';

import 'vendor_earnings_screen.dart';
import 'vendor_home_screen.dart';
import 'vendor_jobs_screen.dart';
import 'vendor_messages_screen.dart';

/// Vendor app scaffold with the bottom navigation bar.
class VendorShell extends StatefulWidget {
  const VendorShell({super.key});

  @override
  State<VendorShell> createState() => _VendorShellState();
}

class _VendorShellState extends State<VendorShell> {
  int _index = 0;

  // IndexedStack children order: 0 Beranda, 1 Pekerjaan, 2 Pesan, 3 Pendapatan.
  static const int _jobs = 1;

  void _goTo(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    final labels = Theme.of(context).textTheme.bodySmall;

    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          VendorHomeScreen(onOpenJobs: () => _goTo(_jobs)),
          const VendorJobsScreen(),
          const VendorMessagesScreen(),
          const VendorEarningsScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: _goTo,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        selectedLabelStyle: labels?.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: labels?.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline_rounded),
            activeIcon: Icon(Icons.work_rounded),
            label: 'Pekerjaan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline_rounded),
            activeIcon: Icon(Icons.chat_bubble_rounded),
            label: 'Pesan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            activeIcon: Icon(Icons.account_balance_wallet_rounded),
            label: 'Pendapatan',
          ),
        ],
      ),
    );
  }
}
