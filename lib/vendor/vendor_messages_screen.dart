import 'package:flutter/material.dart';

import '../models/models.dart';
import '../screens/chat_screen.dart';
import 'vendor_store.dart';
import '../theme.dart';

/// Vendor tab: conversations with the clients (customers) the vendor serves.
///
/// The list is derived from the vendor's jobs — each unique `customerName`
/// becomes a chat target. Tapping a client opens [ChatScreen] so the vendor
/// can communicate directly with them.
class VendorMessagesScreen extends StatelessWidget {
  const VendorMessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = VendorStore.instance;
    // Unique clients, preserving first-seen order.
    final seen = <String>{};
    final List<Worker> clients = [];
    for (final j in store.jobs) {
      if (seen.add(j.customerName)) {
        clients.add(
          Worker(
            id: j.customerName,
            name: j.customerName,
            trade: j.area,
            serviceIds: const [],
            areas: [j.area],
            rating: 0,
            verified: false,
            certifications: const [],
            priceMultiplier: 1,
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Pesan')),
      body: SafeArea(
        child: clients.isEmpty
            ? const Center(child: Text('Belum ada pesan.'))
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                itemCount: clients.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final client = clients[i];
                  return _ClientTile(client: client);
                },
              ),
      ),
    );
  }
}

class _ClientTile extends StatelessWidget {
  const _ClientTile({required this.client});

  final Worker client;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => ChatScreen(worker: client))),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.line),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: client.verified
                  ? const Color(0xFFEFF6FF)
                  : const Color(0xFFF3F4F6),
              child: Text(client.name.split(' ').first),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    client.name,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    client.trade,
                    style: const TextStyle(color: AppColors.muted),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8)),
          ],
        ),
      ),
    );
  }
}
