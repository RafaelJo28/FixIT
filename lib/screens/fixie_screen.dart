import 'package:flutter/material.dart';
import '../theme.dart';

/// Fixie AI chatbot page — placeholder stub wired later to the real AI backend.
class FixieScreen extends StatelessWidget {
  const FixieScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.ink),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Fixie',
          style: TextStyle(
            color: AppColors.ink,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.line),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: AppColors.blue.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.smart_toy_rounded,
                              color: AppColors.blue,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Fixie',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                              color: AppColors.ink,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Halo! Aku Fixie, asisten AI kamu. '
                        'Bisa tanya aku soal jadwal servis, estimasi biaya, '
                        'atau bantuan pilih teknisi terdekat.',
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.5,
                          color: AppColors.body,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Percakapan',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AppColors.muted,
                  ),
                ),
                const SizedBox(height: 12),
                _chatBubble('Ada yang bisa aku bantu hari ini?', true),
                const SizedBox(height: 12),
                _chatBubble('Bisa cari tukang pipe di Bekasi?', false),
                const SizedBox(height: 12),
                _chatBubble('Bisa, saya akan cari tukang pipe terdekat di Bekasi untuk kamu.', true),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.line)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Ketik pesan ke Fixie...',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      maxLines: null,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Material(
                  color: AppColors.blue,
                  borderRadius: BorderRadius.circular(14),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {},
                    child: const Padding(
                      padding: EdgeInsets.all(14),
                      child: Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
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

Widget _chatBubble(String text, bool isFixie) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (isFixie) ...[
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.blue.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.smart_toy_rounded,
            color: AppColors.blue,
            size: 18,
          ),
        ),
        const SizedBox(width: 10),
      ],
      Expanded(
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.line),
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.ink,
            ),
          ),
        ),
      ),
      if (!isFixie) ...[
        const SizedBox(width: 10),
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.muted.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.person_rounded,
            color: AppColors.muted,
            size: 18,
          ),
        ),
      ],
    ],
  );
}