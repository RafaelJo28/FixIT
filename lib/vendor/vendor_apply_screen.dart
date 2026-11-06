import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/specialties.dart';
import '../data/worker_directory.dart';
import '../models/worker_profile.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/worker_widgets.dart';
import 'portfolio_editor.dart';
import 'vendor_pickers.dart';
import 'vendor_shell.dart';
import 'work_hours_editor.dart';

/// Vendor sign-up in five steps. PROTOTYPE ONLY: nothing is sent anywhere,
/// uploads are simulated, and approval is faked on the pending screen.
class VendorApplyScreen extends StatefulWidget {
  const VendorApplyScreen({super.key});

  @override
  State<VendorApplyScreen> createState() => _VendorApplyScreenState();
}

class _VendorApplyScreenState extends State<VendorApplyScreen> {
  static const _titles = [
    'Jadi mitra FixIT',
    'Keahlian & wilayah',
    'Jam kerja',
    'Bukti pekerjaan',
    'Verifikasi dokumen',
  ];

  final _name = TextEditingController();
  final _age = TextEditingController();
  final _bio = TextEditingController();

  int _step = 0;
  Gender? _gender;
  Set<String> _specialties = {};
  Set<String> _areas = {};
  List<DayHours> _hours = defaultWorkHours();
  List<PortfolioItem> _portfolio = [];
  bool _ktp = false;
  bool _selfie = false;
  bool _cert = false;
  final bool _lainnya = false;

  @override
  void initState() {
    super.initState();
    for (final c in [_name, _age, _bio]) {
      c.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    for (final c in [_name, _age, _bio]) {
      c.dispose();
    }
    super.dispose();
  }

  int? get _ageValue {
    final v = int.tryParse(_age.text);
    return (v != null && v >= kAgeMin && v <= kAgeMax) ? v : null;
  }

  bool get _stepValid => switch (_step) {
    0 => _name.text.trim().isNotEmpty && _gender != null && _ageValue != null,
    1 => _specialties.isNotEmpty && _areas.isNotEmpty,
    2 => validWorkHours(_hours),
    3 =>
      _lainnya ||
          _specialties.every((s) => _portfolio.any((p) => p.specialtyId == s)),
    _ => _ktp && _selfie,
  };

  void _setSpecialties(Set<String> next) {
    setState(() {
      _specialties = next;
      // When _lainnya is true, keep all portfolio items.
      // Otherwise, drop proof for specialties that were deselected.
      if (!_lainnya) {
        _portfolio = _portfolio
            .where((p) => next.contains(p.specialtyId))
            .toList();
      }
    });
  }

  void _back() => setState(() => _step--);

  void _next() {
    if (_step == 4) {
      _submit();
    } else {
      setState(() => _step++);
    }
  }

  void _submit() {
    WorkerDirectory.instance.replaceMe(
      WorkerProfile(
        id: WorkerDirectory.meId,
        name: _name.text.trim(),
        gender: _gender!,
        age: _ageValue!,
        bio: _bio.text.trim(),
        specialtyIds: Set<String>.of(_specialties),
        areas: Set<String>.of(_areas),
        workHours: List<DayHours>.of(_hours),
        portfolio: List<PortfolioItem>.of(_portfolio),
        verified: false,
      ),
    );
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

  List<Widget> _content() {
    switch (_step) {
      case 0:
        return [
          const _Label('Nama lengkap'),
          TextField(
            controller: _name,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(hintText: 'Sesuai KTP'),
          ),
          const _Label('Jenis kelamin'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final g in Gender.values)
                SelectChip(
                  label: g.label,
                  selected: _gender == g,
                  onTap: () => setState(() => _gender = g),
                ),
            ],
          ),
          const _Label('Usia'),
          TextField(
            controller: _age,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(2),
            ],
            decoration: InputDecoration(
              hintText: 'Contoh: 32',
              helperText: 'Antara $kAgeMin dan $kAgeMax tahun',
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Usia dan jenis kelamin tampil di profil publikmu supaya pelanggan bisa memilih pekerja yang cocok.',
            style: TextStyle(fontSize: 12, height: 1.4, color: AppColors.muted),
          ),
          const _Label('Tentang kamu (opsional)'),
          TextField(
            controller: _bio,
            maxLines: 3,
            maxLength: 160,
            decoration: const InputDecoration(
              hintText: 'Pengalaman, keahlian khusus, dan gaya kerjamu',
            ),
          ),
        ];
      case 1:
        return [
          const _Label('Keahlian (pilih satu atau lebih)'),
          SpecialtyPicker(selected: _specialties, onChanged: _setSpecialties),
          const _Label('Wilayah layanan'),
          AreaPicker(
            selected: _areas,
            onChanged: (s) => setState(() => _areas = s),
          ),
        ];
      case 2:
        return [
          const Text(
            'Tarif kunjungan disepakati langsung dengan pelanggan dan dicatat setelah harga disetujui.',
            style: TextStyle(
              fontSize: 13.5,
              height: 1.4,
              color: AppColors.body,
            ),
          ),
          const _Label('Jam kerja'),
          WorkHoursEditor(
            hours: _hours,
            onChanged: (h) => setState(() => _hours = h),
          ),
        ];
      case 3:
        return [
          const Text(
            'Unggah foto atau video hasil kerjamu untuk setiap keahlian. Pelanggan melihatnya di profilmu.',
            style: TextStyle(
              fontSize: 13.5,
              height: 1.4,
              color: AppColors.body,
            ),
          ),
          const SizedBox(height: 16),
          PortfolioEditor(
            items: _portfolio,
            specialtyIds: orderedSpecialties(_specialties),
            onChanged: (list) => setState(() => _portfolio = list),
          ),
        ];
      default:
        return [
          _DocTile(
            title: 'Foto KTP',
            subtitle: 'Wajib',
            done: _ktp,
            onTap: () => setState(() => _ktp = !_ktp),
          ),
          const SizedBox(height: 10),
          _DocTile(
            title: 'Foto selfie dengan KTP',
            subtitle: 'Wajib',
            done: _selfie,
            onTap: () => setState(() => _selfie = !_selfie),
          ),
          const SizedBox(height: 10),
          _DocTile(
            title: 'Sertifikat keahlian',
            subtitle: 'Opsional',
            done: _cert,
            onTap: () => setState(() => _cert = !_cert),
          ),
          const SizedBox(height: 12),
          const Text(
            'Mode demo: mengetuk dokumen hanya mensimulasikan unggahan.',
            style: TextStyle(fontSize: 12, color: AppColors.muted),
          ),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _step > 0) _back();
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: _step > 0
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: _back,
                )
              : null,
          title: const Text('Daftar sebagai mitra'),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Langkah ${_step + 1} dari ${_titles.length}',
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.muted,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: (_step + 1) / _titles.length,
                        minHeight: 6,
                        backgroundColor: AppColors.line,
                        color: AppColors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  key: ValueKey(_step),
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  children: [
                    Text(
                      _titles[_step],
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                    if (_step == 0)
                      const Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text(
                          'Mulai dengan data dirimu.',
                          style: TextStyle(fontSize: 14, color: AppColors.body),
                        ),
                      ),
                    const SizedBox(height: 4),
                    ..._content(),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: AppColors.line)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        if (_step > 0) ...[
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _back,
                              child: const Text('Kembali'),
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: _stepValid ? _next : null,
                            child: Text(
                              _step == 4 ? 'Kirim pendaftaran' : 'Lanjut',
                            ),
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: _skip,
                      child: const Text('Lewati (demo)'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
      padding: const EdgeInsets.only(top: 20, bottom: 10),
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
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: done ? AppColors.success : AppColors.line),
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
                color: done ? AppColors.success : AppColors.muted,
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
                  color: done ? AppColors.success : AppColors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shown after the vendor submits the form. In the real app the vendor stays
/// here until an admin approves the account.
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
                'Tim FixIT akan memeriksa dokumen dan bukti pekerjaanmu. Kami menghubungimu lewat WhatsApp setelah verifikasi selesai.',
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
                  onPressed: () {
                    // PROTOTYPE ONLY: approve the account so the demo continues.
                    WorkerDirectory.instance.updateMe((m) => m.verified = true);
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const VendorShell()),
                      (route) => false,
                    );
                  },
                  child: const Text('Lihat dashboard (demo)'),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Mode demo: tombol ini langsung menyetujui akunmu.',
                style: TextStyle(fontSize: 12, color: AppColors.muted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
