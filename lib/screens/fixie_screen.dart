import 'package:flutter/material.dart';

import '../theme.dart';

/// One chat message. [fromFixie] is false for the customer's own messages.
class _Msg {
  const _Msg(this.text, {required this.fromFixie});

  final String text;
  final bool fromFixie;
}

const _greeting =
    'Halo! Aku Fixie, asisten AI FixIT. Ceritakan masalah di rumahmu, '
    'nanti aku bantu pilih layanan yang pas.';

// PROTOTYPE ONLY: every reply is this canned text.
const _demoReply =
    'Terima kasih! Fixie masih dalam pengembangan, jadi balasan ini hanya '
    'contoh. Sebentar lagi aku bisa bantu cek harga dan pesan teknisi.';

const _ideas = [
  'AC kurang dingin',
  'Keran bocor',
  'Listrik sering mati',
  'Berapa biaya cuci AC?',
];

/// Fixie AI assistant tab.
class FixieScreen extends StatefulWidget {
  const FixieScreen({super.key});

  @override
  State<FixieScreen> createState() => _FixieScreenState();
}

class _FixieScreenState extends State<FixieScreen> {
  final _controller = TextEditingController();
  final _scroll = ScrollController();
  final List<_Msg> _messages = [const _Msg(_greeting, fromFixie: true)];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  bool get _canSend => _controller.text.trim().isNotEmpty;

  void _sendText(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages
        ..add(_Msg(text, fromFixie: false))
        ..add(const _Msg(_demoReply, fromFixie: true));
      _controller.clear();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Row(
          children: [
            _FixieAvatar(size: 32),
            SizedBox(width: 10),
            Text('Fixie'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              itemCount: _messages.length,
              itemBuilder: (context, i) => _Bubble(msg: _messages[i]),
            ),
          ),
          if (_messages.length == 1)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final idea in _ideas)
                    ActionChip(
                      label: Text(idea),
                      onPressed: () => _sendText(idea),
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: AppColors.line),
                      labelStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blue,
                      ),
                    ),
                ],
              ),
            ),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: Text(
              'Fixie adalah asisten AI dan bisa keliru. '
              'Dalam keadaan darurat, hubungi 112.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11.5, color: AppColors.muted),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.line)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    minLines: 1,
                    maxLines: 4,
                    textInputAction: TextInputAction.send,
                    onSubmitted: _sendText,
                    decoration: const InputDecoration(
                      hintText: 'Ketik pesan ke Fixie...',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton.filled(
                  onPressed: _canSend
                      ? () => _sendText(_controller.text)
                      : null,
                  icon: const Icon(Icons.send_rounded),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.blue,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.line,
                    fixedSize: const Size(48, 48),
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

class _FixieAvatar extends StatelessWidget {
  const _FixieAvatar({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.blue.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(size * 0.32),
      ),
      child: Icon(
        Icons.smart_toy_rounded,
        color: AppColors.blue,
        size: size * 0.56,
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.msg});

  final _Msg msg;

  @override
  Widget build(BuildContext context) {
    final fromFixie = msg.fromFixie;
    final maxWidth = MediaQuery.sizeOf(context).width * 0.78;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: fromFixie
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (fromFixie) ...[
            const _FixieAvatar(size: 32),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(maxWidth: maxWidth),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: fromFixie ? Colors.white : AppColors.blue,
                border: fromFixie ? Border.all(color: AppColors.line) : null,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(fromFixie ? 4 : 18),
                  bottomRight: Radius.circular(fromFixie ? 18 : 4),
                ),
              ),
              child: Text(
                msg.text,
                style: TextStyle(
                  fontSize: 14.5,
                  height: 1.4,
                  color: fromFixie ? AppColors.ink : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
