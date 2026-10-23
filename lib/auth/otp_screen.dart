import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../screens/root_shell.dart';
import '../theme.dart';
import '../vendor/vendor_apply_screen.dart';
import 'user_role.dart';

class _OtpBox extends StatelessWidget {
  const _OtpBox({
    required this.char,
    required this.active,
    required this.error,
  });

  final String char;
  final bool active;
  final bool error;

  @override
  Widget build(BuildContext context) {
    final borderColor = error
        ? AppColors.danger
        : (active ? AppColors.blue : AppColors.line);
    return Container(
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: active ? 1.8 : 1),
      ),
      child: Text(
        char,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
      ),
    );
  }
}

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.role, required this.phone});

  final UserRole role;
  final String phone;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  static const _demoCode = '123456';
  static const _resendSeconds = 30;

  final _controller = TextEditingController();
  final _focus = FocusNode();
  Timer? _timer;
  int _seconds = _resendSeconds;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _controller.addListener(() {
      setState(() {
        if (_error) _error = false;
      });
    });
    _focus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _seconds = _resendSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() => _seconds--);
      if (_seconds <= 0) t.cancel();
    });
  }

  void _resend() {
    _startTimer();
    setState(() {
      _controller.clear();
      _error = false;
    });
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Kode baru dikirim (demo)'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.ink,
        ),
      );
  }

  void _verify() {
    if (_controller.text != _demoCode) {
      setState(() => _error = true);
      return;
    }
    final Widget next = widget.role == UserRole.customer
        ? const RootShell()
        : const VendorApplyScreen();
    Navigator.of(
      context,
    ).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => next), (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    final text = _controller.text;
    final activeIndex = _focus.hasFocus
        ? (text.length < 6 ? text.length : 5)
        : -1;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Masukkan kode verifikasi',
                style: TextStyle(
                  fontSize: 26,
                  height: 1.2,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 8),
              Text.rich(
                TextSpan(
                  style: const TextStyle(
                    fontSize: 14.5,
                    height: 1.4,
                    color: AppColors.body,
                  ),
                  children: [
                    const TextSpan(
                      text: 'Kami mengirim kode 6 digit ke WhatsApp ',
                    ),
                    TextSpan(
                      text: widget.phone,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      ),
                    ),
                    const TextSpan(text: '.'),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _focus.requestFocus,
                child: Stack(
                  children: [
                    Row(
                      children: [
                        for (var i = 0; i < 6; i++)
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(right: i < 5 ? 8 : 0),
                              child: _OtpBox(
                                char: i < text.length ? text[i] : '',
                                active: i == activeIndex,
                                error: _error,
                              ),
                            ),
                          ),
                      ],
                    ),
                    Positioned.fill(
                      child: Opacity(
                        opacity: 0,
                        child: TextField(
                          controller: _controller,
                          focusNode: _focus,
                          autofocus: true,
                          showCursor: false,
                          enableInteractiveSelection: false,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6),
                          ],
                          decoration: const InputDecoration(
                            filled: false,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            counterText: '',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_error)
                const Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Text(
                    'Kode salah. Coba lagi.',
                    style: TextStyle(fontSize: 13, color: AppColors.danger),
                  ),
                ),
              if (kDebugMode)
                const Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Text(
                    'Mode demo: gunakan kode 123456',
                    style: TextStyle(fontSize: 12.5, color: AppColors.muted),
                  ),
                ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: text.length == 6 ? _verify : null,
                  child: const Text('Verifikasi'),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: _seconds > 0
                    ? Text(
                        'Kirim ulang kode dalam 0:${_seconds.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.muted,
                        ),
                      )
                    : TextButton(
                        onPressed: _resend,
                        child: const Text('Kirim ulang kode'),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
