import 'package:flutter/material.dart';

import '../data/chat_store.dart';
import '../models/models.dart';
import '../theme.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.worker,
    this.isVendor = false,
  });

  final Worker worker;
  final bool isVendor;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _ctrl = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  static const _customerQuickReplies = [
    'Teknisi sudah di jalan?',
    'Kira-kira tiba jam berapa?',
    'Tolong bawa tangga ya Pak',
    'Sudah saya transfer',
  ];

  static const _vendorQuickReplies = [
    'Saya sedang dalam perjalanan.',
    'Sudah tiba di lokasi ya Pak/Bu.',
    'Pengerjaan sudah selesai.',
    'Terima kasih banyak!',
  ];

  @override
  void dispose() {
    _ctrl.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(String text) {
    final clean = text.trim();
    if (clean.isEmpty) return;

    ChatStore.instance.sendMessage(
      widget.worker.name,
      text: clean,
      fromWorker: widget.isVendor,
      senderName: widget.isVendor ? widget.worker.name : 'Joel Pratama',
    );
    _ctrl.clear();

    // Auto-scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 80,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final quickReplies =
        widget.isVendor ? _vendorQuickReplies : _customerQuickReplies;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: widget.worker.verified
                  ? AppColors.purpleTint
                  : const Color(0xFFF3F4F6),
              child: Text(widget.worker.name.split(' ').first),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.worker.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    widget.isVendor ? 'Pelanggan FixIT' : widget.worker.trade,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListenableBuilder(
                listenable: ChatStore.instance,
                builder: (context, _) {
                  final messages =
                      ChatStore.instance.messagesFor(widget.worker.name);

                  if (messages.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          'Mulai percakapan dengan ${widget.worker.name}.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppColors.muted),
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (context, i) {
                      final m = messages[i];
                      // Whether this bubble was sent by current user
                      final isMe = widget.isVendor ? m.fromWorker : !m.fromWorker;
                      final align =
                          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
                      final bg =
                          isMe ? AppColors.royalPurple : Colors.white;
                      final textColor = isMe ? Colors.white : AppColors.ink;

                      return Column(
                        crossAxisAlignment: align,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.sizeOf(context).width * 0.76,
                            ),
                            decoration: BoxDecoration(
                              color: bg,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(16),
                                topRight: const Radius.circular(16),
                                bottomLeft: Radius.circular(isMe ? 16 : 4),
                                bottomRight: Radius.circular(isMe ? 4 : 16),
                              ),
                              border: isMe
                                  ? null
                                  : Border.all(color: AppColors.line),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: isMe
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                Text(
                                  m.text,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: textColor,
                                    height: 1.35,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  m.timeLabel,
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    color: isMe
                                        ? Colors.white.withValues(alpha: 0.7)
                                        : AppColors.muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            // Quick reply chips
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: quickReplies.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final text = quickReplies[i];
                  return ActionChip(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    label: Text(text),
                    labelStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.royalPurple,
                    ),
                    backgroundColor: AppColors.purpleTint,
                    side: const BorderSide(color: AppColors.purpleBorder),
                    onPressed: () => _sendMessage(text),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 12, 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _ctrl,
                      textInputAction: TextInputAction.send,
                      onSubmitted: _sendMessage,
                      decoration: InputDecoration(
                        hintText: 'Tulis pesan...',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: const BorderSide(color: AppColors.line),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: () => _sendMessage(_ctrl.text),
                    icon: const Icon(Icons.send_rounded, size: 20),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.royalPurple,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
