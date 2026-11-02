import 'package:flutter/material.dart';

import 'sample_data.dart';

/// A skill a worker can offer and prove with portfolio items, for example
/// "Cuci AC" or "Pasang Aki". Each one belongs to a home-screen category.
class Specialty {
  const Specialty({
    required this.id,
    required this.name,
    required this.categoryId,
  });

  final String id;
  final String name;
  final String categoryId;

  Color get color => SampleData.categoryById(categoryId).color;
  IconData get icon => SampleData.categoryById(categoryId).icon;
}

const List<Specialty> kSpecialties = [
  Specialty(id: 'ac-clean', name: 'Cuci AC', categoryId: 'ac'),
  Specialty(id: 'ac-freon', name: 'Isi Freon', categoryId: 'ac'),
  Specialty(id: 'ac-install', name: 'Pasang AC', categoryId: 'ac'),
  Specialty(id: 'ac-repair', name: 'Perbaikan AC', categoryId: 'ac'),
  Specialty(id: 'clean-house', name: 'Bersih Rumah', categoryId: 'cleaning'),
  Specialty(id: 'clean-sofa', name: 'Cuci Sofa', categoryId: 'cleaning'),
  Specialty(id: 'clean-mattress', name: 'Cuci Kasur', categoryId: 'cleaning'),
  Specialty(id: 'plumb-leak', name: 'Pipa Bocor', categoryId: 'plumbing'),
  Specialty(id: 'plumb-clog', name: 'Saluran Mampet', categoryId: 'plumbing'),
  Specialty(id: 'plumb-tap', name: 'Pasang Kran', categoryId: 'plumbing'),
  Specialty(id: 'elec-outlet', name: 'Stopkontak & Kabel', categoryId: 'electrical'),
  Specialty(id: 'elec-short', name: 'Korsleting', categoryId: 'electrical'),
  Specialty(id: 'elec-lamp', name: 'Pasang Lampu', categoryId: 'electrical'),
  Specialty(id: 'paint-wall', name: 'Cat Dinding', categoryId: 'painting'),
  Specialty(id: 'paint-ceiling', name: 'Cat Plafon', categoryId: 'painting'),
  Specialty(id: 'gen-battery', name: 'Pasang Aki', categoryId: 'general'),
  Specialty(id: 'gen-computer', name: 'Perbaikan Komputer', categoryId: 'general'),
  Specialty(id: 'gen-furniture', name: 'Pasang Furnitur', categoryId: 'general'),
  Specialty(id: 'gen-fridge', name: 'Servis Kulkas', categoryId: 'general'),
  Specialty(id: 'gen-washer', name: 'Servis Mesin Cuci', categoryId: 'general'),
];

Specialty specialtyById(String id) =>
    kSpecialties.firstWhere((s) => s.id == id);

List<Specialty> specialtiesOfCategory(String categoryId) =>
    kSpecialties.where((s) => s.categoryId == categoryId).toList();

/// The given ids in catalog order, so lists look the same everywhere.
List<String> orderedSpecialties(Iterable<String> ids) {
  final set = ids.toSet();
  return [
    for (final s in kSpecialties)
      if (set.contains(s.id)) s.id,
  ];
}
