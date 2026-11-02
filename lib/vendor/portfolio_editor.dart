import 'package:flutter/material.dart';

import '../data/specialties.dart';
import '../data/worker_directory.dart';
import '../models/worker_profile.dart';
import '../theme.dart';
import '../widgets/worker_widgets.dart';

/// Opens the "add proof of work" sheet. [video] only changes the label and the
/// kind of item that is created; the media itself is simulated for now.
Future<PortfolioItem?> showAddPortfolioSheet(
  BuildContext context, {
  required List<String> specialtyIds,
  required bool video,
  PortfolioItem? existingItem,
}) {
  return showModalBottomSheet<PortfolioItem>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: Colors.white,
    builder: (_) => _AddPortfolioSheet(
      specialtyIds: specialtyIds,
      video: video,
      existingItem: existingItem,
    ),
  );
}

class _AddPortfolioSheet extends StatefulWidget {
  const _AddPortfolioSheet({
    required this.specialtyIds,
    required this.video,
    this.existingItem,
  });

  final List<String> specialtyIds;
  final bool video;
  final PortfolioItem? existingItem;

  @override
  State<_AddPortfolioSheet> createState() => _AddPortfolioSheetState();
}

class _AddPortfolioSheetState extends State<_AddPortfolioSheet> {
  final _caption = TextEditingController();
  String? _specialty;
  bool _picked = false;
  bool _mediaReplaced = false;

  @override
  void initState() {
    super.initState();
    final existing = widget.existingItem;
    _specialty =
        existing?.specialtyId ??
        (widget.specialtyIds.length == 1 ? widget.specialtyIds.first : null);
    _picked = existing != null;
    _caption.text = existing?.caption ?? '';
    _caption.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _caption.dispose();
    super.dispose();
  }

  bool get _ready =>
      _specialty != null && _picked && _caption.text.trim().isNotEmpty;

  void _submit() {
    final caption = _caption.text.trim();
    Navigator.of(context).pop(
      PortfolioItem(
        id:
            widget.existingItem?.id ??
            WorkerDirectory.instance.newPortfolioId(),
        specialtyId: _specialty!,
        caption: caption,
        isVideo: widget.existingItem?.isVideo ?? widget.video,
        durationSec: widget.existingItem != null && !_mediaReplaced
            ? widget.existingItem!.durationSec
            : (widget.video ? 15 + caption.length % 45 : 0),
        shade: widget.existingItem != null && !_mediaReplaced
            ? widget.existingItem!.shade
            : caption.length % 4,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final video = widget.video;
    final editing = widget.existingItem != null;
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          20,
          0,
          20,
          16 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              editing ? 'Edit bukti pekerjaan' : 'Bukti pekerjaan baru',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 14),
            const Text(
              'Untuk keahlian apa?',
              style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final id in widget.specialtyIds)
                  SelectChip(
                    label: specialtyById(id).name,
                    selected: _specialty == id,
                    onTap: () => setState(() => _specialty = id),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => setState(() {
                if (editing) _mediaReplaced = !_picked;
                _picked = !_picked;
              }),
              child: Container(
                height: 110,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: _picked
                      ? AppColors.success.withValues(alpha: 0.08)
                      : AppColors.bg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _picked ? AppColors.success : AppColors.line,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _picked
                          ? Icons.check_circle_rounded
                          : (video
                                ? Icons.video_library_outlined
                                : Icons.add_photo_alternate_outlined),
                      size: 30,
                      color: _picked ? AppColors.success : AppColors.muted,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _picked
                          ? (editing
                                ? (video
                                      ? 'Ganti video dari galeri'
                                      : 'Ganti foto dari galeri')
                                : (video ? 'Video terpilih' : 'Foto terpilih'))
                          : (video
                                ? 'Pilih video dari galeri'
                                : 'Pilih foto dari galeri'),
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Text(
                      'Mode demo: ketuk untuk mensimulasikan unggahan',
                      style: TextStyle(fontSize: 11.5, color: AppColors.muted),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _caption,
              maxLength: 60,
              decoration: const InputDecoration(
                labelText: 'Keterangan',
                hintText: 'Contoh: Cuci AC split 1 PK di Beji',
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _ready ? _submit : null,
                child: Text(editing ? 'Simpan perubahan' : 'Tambahkan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Add/remove portfolio items and see which specialties still lack proof.
class PortfolioEditor extends StatelessWidget {
  const PortfolioEditor({
    super.key,
    required this.items,
    required this.specialtyIds,
    required this.onChanged,
  });

  final List<PortfolioItem> items;
  final List<String> specialtyIds;
  final ValueChanged<List<PortfolioItem>> onChanged;

  Future<void> _add(BuildContext context, {required bool video}) async {
    final item = await showAddPortfolioSheet(
      context,
      specialtyIds: specialtyIds,
      video: video,
    );
    if (item != null) onChanged([...items, item]);
  }

  Future<void> _edit(BuildContext context, PortfolioItem item) async {
    final updated = await showAddPortfolioSheet(
      context,
      specialtyIds: specialtyIds,
      video: item.isVideo,
      existingItem: item,
    );
    if (updated == null) return;
    onChanged([
      for (final current in items)
        if (current.id == item.id) updated else current,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    if (specialtyIds.isEmpty) {
      return const Text(
        'Pilih keahlian dulu supaya kamu bisa menambahkan bukti pekerjaan.',
        style: TextStyle(fontSize: 13.5, color: AppColors.muted),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final id in specialtyIds)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                Icon(
                  items.any((p) => p.specialtyId == id)
                      ? Icons.check_circle_rounded
                      : Icons.error_outline_rounded,
                  size: 20,
                  color: items.any((p) => p.specialtyId == id)
                      ? AppColors.success
                      : const Color(0xFFB45309),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    specialtyById(id).name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  items.any((p) => p.specialtyId == id)
                      ? '${items.where((p) => p.specialtyId == id).length} bukti'
                      : 'Belum ada bukti',
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _add(context, video: false),
                icon: const Icon(Icons.photo_camera_outlined),
                label: const Text('Tambah foto'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _add(context, video: true),
                icon: const Icon(Icons.videocam_outlined),
                label: const Text('Tambah video'),
              ),
            ),
          ],
        ),
        if (items.isNotEmpty)
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            padding: const EdgeInsets.only(top: 14),
            children: [
              for (final it in items)
                PortfolioTile(
                  item: it,
                  onTap: () => _edit(context, it),
                  onDelete: () => onChanged([...items]..remove(it)),
                ),
            ],
          ),
      ],
    );
  }
}

/// Edit the public-facing vendor description and portfolio.
class VendorPortfolioScreen extends StatefulWidget {
  const VendorPortfolioScreen({super.key});

  @override
  State<VendorPortfolioScreen> createState() => _VendorPortfolioScreenState();
}

class _VendorPortfolioScreenState extends State<VendorPortfolioScreen> {
  final _bio = TextEditingController(text: WorkerDirectory.instance.me.bio);

  @override
  void dispose() {
    _bio.dispose();
    super.dispose();
  }

  void _saveBio() {
    WorkerDirectory.instance.updateMe((profile) {
      profile.bio = _bio.text.trim();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Deskripsi profil berhasil disimpan'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dir = WorkerDirectory.instance;
    return ListenableBuilder(
      listenable: dir,
      builder: (context, _) {
        final me = dir.me;
        return Scaffold(
          appBar: AppBar(title: const Text('Profil publik')),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              const Text(
                'Tentang saya',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _bio,
                maxLength: 300,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText:
                      'Ceritakan pengalaman dan cara kerjamu kepada pelanggan',
                  alignLabelWithHint: true,
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _saveBio,
                  child: const Text('Simpan deskripsi'),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Portofolio',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              const Text(
                'Edit keterangan atau ganti foto dan video yang sudah diunggah. Perubahan langsung tersimpan di profil pelanggan.',
                style: TextStyle(
                  fontSize: 13.5,
                  height: 1.4,
                  color: AppColors.body,
                ),
              ),
              const SizedBox(height: 16),
              PortfolioEditor(
                items: me.portfolio,
                specialtyIds: orderedSpecialties(me.specialtyIds),
                onChanged: (list) => dir.updateMe((m) => m.portfolio = list),
              ),
            ],
          ),
        );
      },
    );
  }
}
