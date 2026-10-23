import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/common.dart';
import 'vendor_shell.dart';

class VendorApplyScreen extends StatefulWidget {
  const VendorApplyScreen({super.key});

  @override
  State<VendorApplyScreen> createState() => _VendorApplyScreenState();
}

class _VendorApplyScreenState extends State<VendorApplyScreen> {
  static const _skillOptions = [
    'Servis AC',
    'Kebersihan Rumah',
    'Pipa & Ledeng',
    'Listrik',
    'Cat & Dekorasi',
    'Lainnya',
  ];
  static const _areaOptions = ['Depok', 'Bekasi'];

  final _name = TextEditingController();
  final _skills = <String>{};
  final _areas = <String>{};
  bool _ktp = false;
  bool _selfie = false;
  bool _cert = false;

  @override
  void initState() {
    super.initState();
    _name.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  bool get _ready =>
      _name.text.trim().isNotEmpty &&
      _skills.isNotEmpty &&
      _areas.isNotEmpty &&
      _ktp &&
      _selfie;

  void _toggle(Set<String> set, String value) {
    if (!set.remove(value)) set.add(value);
  }

  void _submit() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const VendorPendingScreen()),
    );
  }

  void _skip() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const VendorShell()),
      (route) => false,
    );
  }

  Widget _chip(String label, Set<String> set) {
    final selected = set.contains(label);
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => setState(() => _toggle(set, label)),
      backgroundColor: Colors.white,
      selectedColor: AppColors.blue.withValues(alpha: 0.14),
      checkmarkColor: AppColors.blue,
      side: BorderSide(color: selected ? AppColors.blue : AppColors.line),
      labelStyle: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: selected ? AppColors.blue : AppColors.body,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jadi mitra FixIT')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          const Text(
            'Lengkapi data untuk mulai menerima pekerjaan',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.body,
            ),
          ),
          const _Label('Nama lengkap'),
          TextField(
            controller: _name,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(hintText: 'Nama sesuai KTP'),
          ),
          const _Label('Keahlian'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [for (final s in _skillOptions) _chip(s, _skills)],
          ),
          const _Label('Wilayah layanan'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [for (final a in _areaOptions) _chip(a, _areas)],
          ),
          const _Label('Dokumen verifikasi'),
          _DocTile(
            title: 'Foto KTP',
            subtitle: 'Upload foto KTP yang masih berlaku',
            done: _ktp,
            onTap: () => setState(() => _ktp = !_ktp),
          ),
          const SizedBox(height: 10),
          _DocTile(
            title: 'Foto selfie dengan KTP',
            subtitle: 'Pastikan wajah dan KTP terlihat jelas',
            done: _selfie,
            onTap: () => setState(() => _selfie = !_selfie),
          ),
          const SizedBox(height: 10),
          _DocTile(
            title: 'Sertifikat keahlian',
            subtitle: 'Opsional, tapi membantu meningkatkan kepercayaan',
            done: _cert,
            onTap: () => setState(() => _cert = !_cert),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _ready ? _submit : null,
              child: const Text('Kirim pendaftaran'),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: _skip,
              child: const Text('Lewati dulu (demo)'),
            ),
          ),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 22, bottom: 10),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _DocTile extends StatelessWidget {
  const _DocTile({
    required this.title,
    required this.subtitle,
    required this.done,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool done;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const green = AppColors.success;
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: done ? green : AppColors.line),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Icon(
                done ? Icons.check_circle_rounded : Icons.upload_file_outlined,
                color: done ? green : AppColors.muted,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                done ? 'Terunggah' : 'Unggah',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: done ? green : AppColors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VendorPendingScreen extends StatelessWidget {
  const VendorPendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const IconBadge(
                icon: Icons.hourglass_bottom_rounded,
                color: AppColors.blue,
                size: 84,
              ),
              const SizedBox(height: 24),
              const Text(
                'Pendaftaran terkirim',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Tim FixIT akan memeriksa dokumenmu. Kami menghubungimu lewat WhatsApp setelah verifikasi selesai.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.5,
                  height: 1.45,
                  color: AppColors.body,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const VendorShell()),
                    (route) => false,
                  ),
                  child: const Text('Lihat dashboard (demo)'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
