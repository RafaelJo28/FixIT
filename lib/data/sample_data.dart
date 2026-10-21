import 'dart:math';

import 'package:flutter/material.dart';

import '../models/models.dart';

/// Hard-coded prototype data. Replace with Neon-backed API later.
class SampleData {
  SampleData._();

  static const String city = 'Depok / Bekasi';

  static const List<ServiceCategory> categories = [
    ServiceCategory(
      id: 'ac',
      name: 'Servis AC',
      icon: Icons.ac_unit_rounded,
      color: Color(0xFF2563EB),
    ),
    ServiceCategory(
      id: 'cleaning',
      name: 'Kebersihan Rumah',
      icon: Icons.cleaning_services_rounded,
      color: Color(0xFF0EA5E9),
    ),
    ServiceCategory(
      id: 'plumbing',
      name: 'Pipa & Ledeng',
      icon: Icons.plumbing_rounded,
      color: Color(0xFF0284C7),
    ),
    ServiceCategory(
      id: 'electrical',
      name: 'Listrik',
      icon: Icons.electrical_services_rounded,
      color: Color(0xFF1D4ED8),
    ),
    ServiceCategory(
      id: 'painting',
      name: 'Cat & Dekorasi',
      icon: Icons.format_paint_rounded,
      color: Color(0xFF3B82F6),
    ),
    ServiceCategory(
      id: 'general',
      name: 'Lainnya',
      icon: Icons.apps_rounded,
      color: Color(0xFF1E40AF),
    ),
  ];

  static const List<ServiceItem> services = [
    ServiceItem(
      id: 'ac-clean-1',
      categoryId: 'ac',
      name: 'Servis & Cuci AC',
      description: 'Cuci unit indoor & outdoor secara menyeluruh, cek refrigeran, dan tune-up dasar oleh teknisi bersertifikat.',
      price: 95000,
      rating: 4.9,
      durationMinutes: 90,
      popular: true,
    ),
    ServiceItem(
      id: 'ac-install-1',
      categoryId: 'ac',
      name: 'Pasang / Copot AC',
      description: 'Pasang atau bongkar unit AC split dengan aman, termasuk instalasi pipa.',
      price: 150000,
      rating: 4.8,
      durationMinutes: 120,
    ),
    ServiceItem(
      id: 'clean-regular-1',
      categoryId: 'cleaning',
      name: 'Pembersihan Rumah Rutin',
      description: 'Rapikan rumah, bersihkan debu, mengepel, dan membersihkan kamar mandi untuk rumah studio/1 kamar.',
      price: 120000,
      rating: 4.7,
      durationMinutes: 150,
      popular: true,
    ),
    ServiceItem(
      id: 'clean-deep-1',
      categoryId: 'cleaning',
      name: 'Pembersihan Mendalam',
      description: 'Pembersihan menyeluruh dari atas ke bawah termasuk dapur, jendela, dan area sulit dijangkau.',
      price: 250000,
      rating: 4.8,
      durationMinutes: 240,
    ),
    ServiceItem(
      id: 'plumb-leak-1',
      categoryId: 'plumbing',
      name: 'Perbaikan Kebocoran',
      description: 'Temukan dan perbaiki keran, pipa, atau kran yang bocor. Biaya suku cadang ditagih terpisah bila diperlukan.',
      price: 85000,
      rating: 4.6,
      durationMinutes: 60,
      popular: true,
    ),
    ServiceItem(
      id: 'plumb-toilet-1',
      categoryId: 'plumbing',
      name: 'Bersihkan Saluran Toilet',
      description: 'Bersihkan toilet atau saluran yang tersumbat dengan alat profesional.',
      price: 110000,
      rating: 4.7,
      durationMinutes: 60,
    ),
    ServiceItem(
      id: 'elec-wiring-1',
      categoryId: 'electrical',
      name: 'Perbaikan Stopkontak & Instalasi',
      description: 'Perbaikan atau pemasangan stopkontak, saklar, dan fitting lampu dengan aman.',
      price: 100000,
      rating: 4.8,
      durationMinutes: 75,
      popular: true,
    ),
    ServiceItem(
      id: 'elec-mcb-1',
      categoryId: 'electrical',
      name: 'Cek MCB / Panel',
      description: 'Diagnosa breaker yang trip dan masalah panel listrik di rumah Anda.',
      price: 130000,
      rating: 4.7,
      durationMinutes: 90,
    ),
    ServiceItem(
      id: 'paint-room-1',
      categoryId: 'painting',
      name: 'Cat Ulang Ruangan',
      description: 'Cat ulang satu ruangan (hingga 3x3m). Biaya cat ditagih terpisah.',
      price: 350000,
      rating: 4.9,
      durationMinutes: 300,
    ),
    ServiceItem(
      id: 'general-mount-1',
      categoryId: 'general',
      name: 'Pasang Furnitur',
      description: 'Pasang rak, TV, atau lemari di dinding — bor dan jangkar termasuk.',
      price: 90000,
      rating: 4.8,
      durationMinutes: 60,
      popular: true,
      icon: Icons.chair_rounded,
    ),
    ServiceItem(
      id: 'general-assembly-1',
      categoryId: 'general',
      name: 'Rangka Kayu / Besi',
      description: 'Pemasangan rangka untuk meja, kursi, atau rak baja dan kayu.',
      price: 110000,
      rating: 4.7,
      durationMinutes: 90,
      icon: Icons.highlight_rounded,
    ),
    ServiceItem(
      id: 'general-clean-1',
      categoryId: 'cleaning',
      name: 'Cuci Sofa & Kursi',
      description: 'Pembersihan menyeluruh sofa dan kursi rumah dengan alat cuci vakum.',
      price: 150000,
      rating: 4.6,
      durationMinutes: 120,
      icon: Icons.cleaning_services_rounded,
    ),
    ServiceItem(
      id: 'general-install-1',
      categoryId: 'electrical',
      name: 'Pasang Stopkontak & Kabel',
      description: 'Pemasangan kabel, stopkontak, dan fitting listrik di rumah.',
      price: 130000,
      rating: 4.7,
      durationMinutes: 100,
      icon: Icons.electrical_services_rounded,
    ),
  ];

  static const List<PaymentMethod> paymentMethods = [
    PaymentMethod(
      id: 'gopay',
      name: 'GoPay',
      brandColor: Color(0xFF00AED6),
      tag: 'GO',
    ),
    PaymentMethod(
      id: 'dana',
      name: 'DANA',
      brandColor: Color(0xFF118EEA),
      tag: 'D',
    ),
  ];

  static const List<TimeSlot> timeSlots = [
    TimeSlot(label: '08:00'),
    TimeSlot(label: '09:30'),
    TimeSlot(label: '11:00'),
    TimeSlot(label: '13:00'),
    TimeSlot(label: '14:30'),
    TimeSlot(label: '16:00'),
    TimeSlot(label: '17:30', enabled: false),
    TimeSlot(label: '19:00', enabled: false),
  ];

  // Sample worker profiles for marketplace & assignment logic.
  static const int premiumFee = 25000;

  static const List<Worker> workers = [
    Worker(
      id: 'w_ac_1',
      name: 'Rudi Santoso',
      trade: 'Teknisi AC',
      serviceIds: ['ac-clean-1', 'ac-install-1'],
      areas: ['Depok / Bekasi'],
      rating: 4.9,
      verified: true,
      certifications: ['Sertifikat AC', 'Keselamatan Listrik'],
      priceMultiplier: 1.0,
    ),
    Worker(
      id: 'w_ac_2',
      name: 'Agus Wijaya',
      trade: 'Teknisi AC',
      serviceIds: ['ac-clean-1'],
      areas: ['Depok / Bekasi'],
      rating: 4.4,
      verified: false,
      certifications: [],
      priceMultiplier: 0.95,
    ),
    Worker(
      id: 'w_clean_1',
      name: 'Siti Aminah',
      trade: 'Cleaning Service',
      serviceIds: ['clean-regular-1', 'clean-deep-1'],
      areas: ['Depok / Bekasi'],
      rating: 4.8,
      verified: true,
      certifications: ['Pelatihan Pembersihan Mendalam'],
      priceMultiplier: 1.0,
    ),
    Worker(
      id: 'w_plumb_1',
      name: 'Budi Hartono',
      trade: 'Tukang Pipa',
      serviceIds: ['plumb-leak-1', 'plumb-toilet-1'],
      areas: ['Depok / Bekasi'],
      rating: 4.6,
      verified: true,
      certifications: ['SNI Plumbing'],
      priceMultiplier: 1.0,
    ),
    Worker(
      id: 'w_elec_1',
      name: 'Dewi Kurnia',
      trade: 'Teknisi Listrik',
      serviceIds: ['elec-wiring-1', 'elec-mcb-1'],
      areas: ['Depok / Bekasi'],
      rating: 4.7,
      verified: false,
      certifications: ['Teknisi Listrik Bersertifikat'],
      priceMultiplier: 1.05,
    ),
  ];

  static List<Worker> workersForService(String serviceId, String area) =>
      workers
          .where(
            (w) => w.serviceIds.contains(serviceId) && w.areas.contains(area),
          )
          .toList();

  /// Assign a worker for a service. If [premium] is true, pick the highest-rated
  /// available worker (customer pays a premium fee). Otherwise pick randomly
  /// (fair distribution for lower-tier workers).
  static Worker assignWorker(
    String serviceId,
    String area, {
    bool premium = false,
  }) {
    var candidates = workersForService(serviceId, area);
    if (candidates.isEmpty) {
      candidates = workers
          .where((w) => w.serviceIds.contains(serviceId))
          .toList();
    }
    if (candidates.isEmpty) {
      // Fallback: return the first worker in the sample list.
      return workers.first;
    }

    if (premium) {
      candidates.sort((a, b) => b.rating.compareTo(a.rating));
      return candidates.first;
    }

    final rnd = Random();
    return candidates[rnd.nextInt(candidates.length)];
  }

  static ServiceCategory categoryById(String id) =>
      categories.firstWhere((c) => c.id == id);

  static List<ServiceItem> servicesByCategory(String id) =>
      services.where((s) => s.categoryId == id).toList();

  static List<ServiceItem> popularServices() =>
      services.where((s) => s.popular).toList();

  static ServiceItem serviceById(String id) =>
      services.firstWhere((s) => s.id == id);
}

/// Formats an integer amount as Indonesian Rupiah, e.g. 95000 -> "Rp95.000".
String formatIdr(int amount) {
  final s = amount.toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) {
      buf.write('.');
    }
    buf.write(s[i]);
  }
  return 'Rp$buf';
}
