import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme.dart';
import '../widgets/common.dart';
import 'otp_screen.dart';
import 'user_role.dart';

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key, required this.role});

  final UserRole role;

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _digits {
    var d = _controller.text.replaceAll(RegExp(r'\D'), '');
    while (d.startsWith('0')) {
      d = d.substring(1);
    }
    return d;
  }

  bool get _valid =>
      _digits.startsWith('8') && _digits.length >= 9 && _digits.length <= 12;

  void _send() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => OtpScreen(role: widget.role, phone: '+62$_digits'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isVendor = widget.role == UserRole.vendor;
    final showError = _controller.text.isNotEmpty && !_valid;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isVendor
                    ? 'Masuk sebagai mitra'
                    : 'Masuk dengan nomor WhatsApp',
                style: const TextStyle(
                  fontSize: 26,
                  height: 1.2,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isVendor
                    ? 'Masukkan nomor WhatsApp aktifmu. Kami kirim kode verifikasi 6 digit ke sana.'
                    : 'Kami akan mengirim kode verifikasi 6 digit ke WhatsApp kamu.',
                style: const TextStyle(
                  fontSize: 14.5,
                  height: 1.4,
                  color: AppColors.body,
                ),
              ),
              const SizedBox(height: 28),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 52,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.center,
                    decoration: cardDecoration(radius: 16),
                    child: const Text(
                      '+62',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      keyboardType: TextInputType.phone,
                      maxLength: 13,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: const InputDecoration(
                        hintText: '812 3456 7890',
                        counterText: '',
                      ),
                    ),
                  ),
                ],
              ),
              if (showError)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    'Masukkan nomor HP Indonesia yang valid, contoh 812 3456 7890.',
                    style: TextStyle(fontSize: 12.5, color: AppColors.danger),
                  ),
                ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _valid ? _send : null,
                  child: const Text('Kirim kode via WhatsApp'),
                ),
              ),
              if (!isVendor) ...[
                const SizedBox(height: 20),
                const Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'atau',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: AppColors.muted,
                        ),
                      ),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => comingSoon(context, 'Masuk dengan Google'),
                    icon: const Icon(Icons.mail_outline_rounded),
                    label: const Text('Lanjut dengan Google'),
                  ),
                ),
              ] else ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: cardDecoration(),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 20,
                        color: AppColors.blue,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Mitra wajib memakai nomor WhatsApp agar pelanggan dan tim FixIT bisa menghubungimu.',
                          style: TextStyle(
                            fontSize: 12.5,
                            height: 1.4,
                            color: AppColors.body,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
