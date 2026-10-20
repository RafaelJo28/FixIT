import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import '../models/models.dart';
import 'chat_screen.dart';

/// Simple conversations list. Tapping a worker opens a local chat screen.
class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final workers = SampleData.workers;

    return Scaffold(
      appBar: AppBar(title: const Text('Pesan')),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          itemCount: workers.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, i) {
            final w = workers[i];
            return InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => ChatScreen(worker: w)),
              ),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE6EBF5)),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: w.verified ? const Color(0xFFEFF6FF) : const Color(0xFFF3F4F6),
                      child: Text(w.name.split(' ').first),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(w.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 4),
                          Text(w.trade, style: const TextStyle(color: Color(0xFF64748B))),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
