import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import '../data/specialties.dart';
import '../models/worker_profile.dart';
import '../theme.dart';
import '../widgets/worker_widgets.dart';

/// Specialties grouped by home-screen category, as selectable chips.
class SpecialtyPicker extends StatelessWidget {
  const SpecialtyPicker({super.key, required this.selected, required this.onChanged});

  final Set<String> selected;
  final ValueChanged<Set<String>> onChanged;

  void _toggle(String id) {
    final next = Set<String>.of(selected);
    if (!next.remove(id)) next.add(id);
    onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final c in SampleData.categories) ...[
          Padding(
            padding: const EdgeInsets.only(top: 6, bottom: 8),
            child: Text(
              c.name,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: AppColors.muted,
              ),
            ),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final s in specialtiesOfCategory(c.id))
                SelectChip(
                  label: s.name,
                  selected: selected.contains(s.id),
                  onTap: () => _toggle(s.id),
                ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

/// Service areas (Depok / Bekasi) as selectable chips.
class AreaPicker extends StatelessWidget {
  const AreaPicker({super.key, required this.selected, required this.onChanged});

  final Set<String> selected;
  final ValueChanged<Set<String>> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final a in kAreas)
          SelectChip(
            label: a,
            selected: selected.contains(a),
            onTap: () {
              final next = Set<String>.of(selected);
              if (!next.remove(a)) next.add(a);
              onChanged(next);
            },
          ),
      ],
    );
  }
}

/// Bottom sheet to edit one set of chips. Returns the new set, or null if
/// the person closed the sheet without saving.
Future<Set<String>?> showPickerSheet(
  BuildContext context, {
  required String title,
  required Set<String> initial,
  required bool specialties,
}) {
  return showModalBottomSheet<Set<String>>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: Colors.white,
    builder: (_) => _PickerSheet(title: title, initial: initial, specialties: specialties),
  );
}

class _PickerSheet extends StatefulWidget {
  const _PickerSheet({
    required this.title,
    required this.initial,
    required this.specialties,
  });

  final String title;
  final Set<String> initial;
  final bool specialties;

  @override
  State<_PickerSheet> createState() => _PickerSheetState();
}

class _PickerSheetState extends State<_PickerSheet> {
  late Set<String> _selected = Set<String>.of(widget.initial);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.8,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              Flexible(
                child: SingleChildScrollView(
                  child: widget.specialties
                      ? SpecialtyPicker(
                          selected: _selected,
                          onChanged: (s) => setState(() => _selected = s),
                        )
                      : AreaPicker(
                          selected: _selected,
                          onChanged: (s) => setState(() => _selected = s),
                        ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _selected.isEmpty
                      ? null
                      : () => Navigator.of(context).pop(_selected),
                  child: const Text('Simpan pilihan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
