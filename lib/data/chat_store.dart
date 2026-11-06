import 'package:flutter/foundation.dart';

class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.senderName,
    required this.text,
    required this.timeLabel,
    required this.fromWorker,
  });

  final String id;
  final String senderName;
  final String text;
  final String timeLabel;
  final bool fromWorker;
}

/// Shared in-memory chat store for both Customer and Vendor.
///
/// When a customer messages a technician, the technician sees it in the vendor
/// app. When the technician replies, the customer sees it in real-time.
class ChatStore extends ChangeNotifier {
  ChatStore._() {
    _seed();
  }

  static final ChatStore instance = ChatStore._();

  final Map<String, List<ChatMessage>> _threads = {};
  int _counter = 0;

  List<ChatMessage> messagesFor(String contactKey) {
    return List.unmodifiable(_threads[contactKey] ?? []);
  }

  void sendMessage(
    String contactKey, {
    required String text,
    required bool fromWorker,
    required String senderName,
  }) {
    final list = _threads.putIfAbsent(contactKey, () => []);
    final now = DateTime.now();
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    list.add(
      ChatMessage(
        id: 'm_${_counter++}',
        senderName: senderName,
        text: text,
        timeLabel: timeStr,
        fromWorker: fromWorker,
      ),
    );
    notifyListeners();
  }

  void reset() {
    _seed();
    notifyListeners();
  }

  void _seed() {
    _counter = 0;
    _threads.clear();

    // Default thread for Hendra Saputra (the vendor 'me')
    _threads['Hendra Saputra'] = [
      ChatMessage(
        id: 'm_${_counter++}',
        senderName: 'Hendra Saputra',
        text: 'Halo! Saya teknisi yang akan menangani servis AC Anda.',
        timeLabel: '10:00',
        fromWorker: true,
      ),
      ChatMessage(
        id: 'm_${_counter++}',
        senderName: 'Joel Pratama',
        text: 'Siang Pak Hendra, kira-kira butuh berapa lama pengerjaannya?',
        timeLabel: '10:05',
        fromWorker: false,
      ),
      ChatMessage(
        id: 'm_${_counter++}',
        senderName: 'Hendra Saputra',
        text: 'Untuk cuci dan cek freon biasanya 60-90 menit, Pak. Saya bawa alat lengkap.',
        timeLabel: '10:07',
        fromWorker: true,
      ),
    ];

    // Mirror thread for Sinta (client on vendor app)
    _threads['Sinta'] = [
      ChatMessage(
        id: 'm_${_counter++}',
        senderName: 'Sinta',
        text: 'Pak Hendra, tolong kabari kalau sudah jalan ya.',
        timeLabel: '12:30',
        fromWorker: false,
      ),
      ChatMessage(
        id: 'm_${_counter++}',
        senderName: 'Hendra Saputra',
        text: 'Siap Bu Sinta, sedang bersiap menuju lokasi sekarang.',
        timeLabel: '12:32',
        fromWorker: true,
      ),
    ];

    _threads['Rudi Santoso'] = [
      ChatMessage(
        id: 'm_${_counter++}',
        senderName: 'Rudi Santoso',
        text: 'Halo, ada yang bisa saya bantu terkait AC Anda?',
        timeLabel: 'Kemarin',
        fromWorker: true,
      ),
    ];

    _threads['Siti Aminah'] = [
      ChatMessage(
        id: 'm_${_counter++}',
        senderName: 'Siti Aminah',
        text: 'Halo Kak, untuk pembersihan rumah siap kami jadwalkan ya.',
        timeLabel: '2 hari lalu',
        fromWorker: true,
      ),
    ];

    _threads['Budi Hartono'] = [
      ChatMessage(
        id: 'm_${_counter++}',
        senderName: 'Budi Hartono',
        text: 'Halo Pak, pipa yang bocor di sebelah mana ya?',
        timeLabel: '3 hari lalu',
        fromWorker: true,
      ),
    ];
  }
}

