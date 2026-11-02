import 'package:flutter/foundation.dart';

import '../models/worker_profile.dart';
import 'sample_data.dart';
import 'specialties.dart';

enum WorkerSort { rating, priceLow, priceHigh, experience }

extension WorkerSortX on WorkerSort {
  String get label => switch (this) {
    WorkerSort.rating => 'Rating tertinggi',
    WorkerSort.priceLow => 'Tarif terendah',
    WorkerSort.priceHigh => 'Tarif tertinggi',
    WorkerSort.experience => 'Paling berpengalaman',
  };
}

const Object _unset = Object();

int _compareVisitRates(int? a, int? b, {required bool descending}) {
  if (a == null) return b == null ? 0 : 1;
  if (b == null) return -1;
  return descending ? b.compareTo(a) : a.compareTo(b);
}

/// Search text plus the filters customers can apply when looking for workers.
class WorkerFilter {
  const WorkerFilter({
    this.query = '',
    this.categoryId,
    this.specialtyId,
    this.gender,
    this.minAge = kAgeMin,
    this.maxAge = kAgeMax,
    this.minRating = 0,
    this.maxRating = 5,
    this.minPrice = kPriceMin,
    this.maxPrice = kPriceMax,
    this.sort = WorkerSort.rating,
  });

  final String query;
  final String? categoryId;
  final String? specialtyId;
  final Gender? gender;
  final int minAge;
  final int maxAge;
  final double minRating;
  final double maxRating;
  final int minPrice;
  final int maxPrice;
  final WorkerSort sort;

  WorkerFilter copyWith({
    String? query,
    Object? categoryId = _unset,
    Object? specialtyId = _unset,
    Object? gender = _unset,
    int? minAge,
    int? maxAge,
    double? minRating,
    double? maxRating,
    int? minPrice,
    int? maxPrice,
    WorkerSort? sort,
  }) {
    return WorkerFilter(
      query: query ?? this.query,
      categoryId: identical(categoryId, _unset)
          ? this.categoryId
          : categoryId as String?,
      specialtyId: identical(specialtyId, _unset)
          ? this.specialtyId
          : specialtyId as String?,
      gender: identical(gender, _unset) ? this.gender : gender as Gender?,
      minAge: minAge ?? this.minAge,
      maxAge: maxAge ?? this.maxAge,
      minRating: minRating ?? this.minRating,
      maxRating: maxRating ?? this.maxRating,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      sort: sort ?? this.sort,
    );
  }

  /// How many of the sheet filters (age, gender, rating, price, specialty)
  /// differ from their defaults. Used for the badge on the filter button.
  int get activeCount =>
      (gender != null ? 1 : 0) +
      (minAge != kAgeMin || maxAge != kAgeMax ? 1 : 0) +
      (minRating != 0 || maxRating != 5 ? 1 : 0) +
      (minPrice != kPriceMin || maxPrice != kPriceMax ? 1 : 0) +
      (specialtyId != null ? 1 : 0);

  bool matches(WorkerProfile w) {
    if (gender != null && w.gender != gender) return false;
    if (w.age < minAge || w.age > maxAge) return false;
    if (w.rating < minRating || w.rating > maxRating) return false;
    final rate = w.visitRate;
    if (rate == null) {
      if (minPrice != kPriceMin || maxPrice != kPriceMax) return false;
    } else if (rate < minPrice || rate > maxPrice) {
      return false;
    }
    if (specialtyId != null && !w.specialtyIds.contains(specialtyId)) {
      return false;
    }
    if (categoryId != null &&
        !w.specialtyIds.any(
          (id) => specialtyById(id).categoryId == categoryId,
        )) {
      return false;
    }
    final tokens = query
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .where((t) => t.isNotEmpty)
        .toList();
    if (tokens.isEmpty) return true;
    final hay = _haystack(w);
    return tokens.every(hay.contains);
  }

  int compare(WorkerProfile a, WorkerProfile b) => switch (sort) {
    WorkerSort.rating => b.rating.compareTo(a.rating),
    WorkerSort.priceLow => _compareVisitRates(
      a.visitRate,
      b.visitRate,
      descending: false,
    ),
    WorkerSort.priceHigh => _compareVisitRates(
      a.visitRate,
      b.visitRate,
      descending: true,
    ),
    WorkerSort.experience => b.jobsDone.compareTo(a.jobsDone),
  };

  static String _haystack(WorkerProfile w) {
    final parts = <String>[
      w.name,
      ...w.areas,
      for (final id in w.specialtyIds) specialtyById(id).name,
      for (final id in w.specialtyIds)
        SampleData.categoryById(specialtyById(id).categoryId).name,
    ];
    return parts.join(' ').toLowerCase();
  }
}

/// In-memory list of all workers. The vendor app edits the profile with
/// id [meId]; the customer app searches and reads the same objects, so a change
/// on the vendor side shows up for customers straight away.
///
/// PROTOTYPE ONLY: replaced by backend queries later.
class WorkerDirectory extends ChangeNotifier {
  WorkerDirectory._() {
    _seed();
  }

  static final WorkerDirectory instance = WorkerDirectory._();

  static const String meId = 'me';

  List<WorkerProfile> _workers = [];
  int _counter = 0;

  /// Everyone, including accounts still waiting for verification.
  List<WorkerProfile> get all => List.unmodifiable(_workers);

  /// What customers can find: verified workers only.
  List<WorkerProfile> get listed => _workers.where((w) => w.verified).toList();

  WorkerProfile get me => _workers.firstWhere((w) => w.id == meId);

  WorkerProfile? byId(String id) {
    for (final w in _workers) {
      if (w.id == id) return w;
    }
    return null;
  }

  List<WorkerProfile> search(WorkerFilter filter) {
    final result = listed.where(filter.matches).toList();
    result.sort(filter.compare);
    return result;
  }

  String newPortfolioId() => 'p${_counter++}';

  /// Edit the vendor's own profile in place and tell listeners.
  void updateMe(void Function(WorkerProfile me) edit) {
    edit(me);
    notifyListeners();
  }

  /// Used when a new vendor finishes the registration form.
  void replaceMe(WorkerProfile profile) {
    _workers = [
      for (final w in _workers)
        if (w.id == meId) profile else w,
    ];
    notifyListeners();
  }

  void addReview(
    String workerId, {
    required String customerName,
    required int rating,
    required String comment,
    String? specialtyId,
  }) {
    final w = byId(workerId);
    if (w == null) return;
    w.addRating(rating);
    w.reviews.insert(
      0,
      Review(
        customerName: customerName,
        rating: rating,
        comment: comment,
        dateLabel: 'Baru saja',
        specialtyId: specialtyId,
      ),
    );
    notifyListeners();
  }

  /// Restores the demo data (used by tests).
  void reset() {
    _seed();
    notifyListeners();
  }

  PortfolioItem _p(String specialtyId, String caption, {int video = 0}) {
    final id = 'p${_counter++}';
    return PortfolioItem(
      id: id,
      specialtyId: specialtyId,
      caption: caption,
      isVideo: video > 0,
      durationSec: video,
      shade: _counter % 4,
    );
  }

  Review _r(String name, int stars, String comment, String date) => Review(
    customerName: name,
    rating: stars,
    comment: comment,
    dateLabel: date,
  );

  void _seed() {
    _counter = 0;
    const allDays = DayHours(8 * 60, 16 * 60);
    _workers = [
      WorkerProfile(
        id: meId,
        name: 'Hendra Saputra',
        gender: Gender.male,
        age: 38,
        bio: 'Teknisi AC dan listrik rumah tangga sejak 2012. Kerja rapi, tepat waktu, dan jujur soal biaya.',
        specialtyIds: {'ac-clean', 'ac-freon', 'elec-outlet'},
        areas: {'Depok', 'Bekasi'},
        visitRate: 120000,
        ratingCount: 126,
        ratingSum: 605,
        jobsDone: 126,
        portfolio: [
          _p('ac-clean', 'Cuci AC split 1 PK di Beji'),
          _p('ac-clean', 'Proses cuci unit indoor dan outdoor', video: 32),
          _p('ac-freon', 'Isi freon R32 setelah cek kebocoran'),
          _p('elec-outlet', 'Pasang 3 stopkontak ruang kerja'),
        ],
        reviews: [
          _r(
            'Sinta',
            5,
            'Cepat, rapi, dan AC langsung dingin lagi.',
            '2 hari lalu',
          ),
          _r(
            'Lia',
            5,
            'Datang tepat waktu dan menjelaskan semuanya dengan jelas.',
            '1 minggu lalu',
          ),
          _r(
            'Andi',
            4,
            'Hasil bagus, hanya sedikit terlambat.',
            '2 minggu lalu',
          ),
        ],
      ),
      WorkerProfile(
        id: 'w_rudi',
        name: 'Rudi Santoso',
        gender: Gender.male,
        age: 34,
        bio: 'Spesialis servis dan pasang AC. Bersertifikat dan berpengalaman 9 tahun.',
        specialtyIds: {'ac-clean', 'ac-install', 'ac-repair'},
        areas: {'Depok'},
        visitRate: 110000,
        ratingCount: 210,
        ratingSum: 1029,
        jobsDone: 210,
        workHours: [
          for (var i = 0; i < 6; i++) const DayHours(7 * 60, 18 * 60),
          const DayHours.closed(),
        ],
        portfolio: [
          _p('ac-install', 'Pasang AC baru 2 PK'),
          _p('ac-repair', 'Perbaikan AC bocor air', video: 41),
          _p('ac-clean', 'Cuci AC kantor kecil'),
        ],
        reviews: [
          _r(
            'Tiara',
            5,
            'Profesional banget, AC baru terpasang rapi.',
            '3 hari lalu',
          ),
          _r('Fajar', 5, 'Masalah AC bocor langsung beres.', '1 minggu lalu'),
        ],
      ),
      WorkerProfile(
        id: 'w_agus',
        name: 'Agus Wijaya',
        gender: Gender.male,
        age: 45,
        bio: 'Cuci AC dan isi freon dengan harga bersahabat.',
        specialtyIds: {'ac-clean', 'ac-freon'},
        areas: {'Bekasi'},
        visitRate: 85000,
        ratingCount: 48,
        ratingSum: 211.2,
        jobsDone: 48,
        portfolio: [
          _p('ac-clean', 'Cuci AC 3 unit rumah tinggal'),
          _p('ac-freon', 'Tambah freon AC split', video: 19),
        ],
        reviews: [
          _r('Dian', 4, 'Hasil bagus, datang agak telat.', '5 hari lalu'),
          _r('Yoga', 5, 'Harga murah dan kerjanya teliti.', '3 minggu lalu'),
        ],
      ),
      WorkerProfile(
        id: 'w_siti',
        name: 'Siti Aminah',
        gender: Gender.female,
        age: 29,
        bio: 'Pembersihan rumah detail, cuci sofa dan kasur dengan alat vakum profesional.',
        specialtyIds: {'clean-house', 'clean-sofa', 'clean-mattress'},
        areas: {'Depok', 'Bekasi'},
        visitRate: 90000,
        ratingCount: 167,
        ratingSum: 801.6,
        jobsDone: 167,
        workHours: List.filled(7, allDays),
        portfolio: [
          _p('clean-house', 'Bersih rumah 2 lantai setelah renovasi'),
          _p('clean-sofa', 'Sofa 3 dudukan sebelum dan sesudah'),
          _p('clean-mattress', 'Cuci kasur king size', video: 24),
          _p('clean-sofa', 'Cuci kursi makan 6 buah'),
        ],
        reviews: [
          _r('Nadia', 5, 'Rumah jadi kinclong, orangnya ramah.', '1 hari lalu'),
          _r('Bayu', 5, 'Sofa bersih seperti baru.', '6 hari lalu'),
          _r('Putri', 4, 'Bagus, tapi butuh waktu agak lama.', '2 minggu lalu'),
        ],
      ),
      WorkerProfile(
        id: 'w_maya',
        name: 'Maya Lestari',
        gender: Gender.female,
        age: 33,
        bio: 'Fokus cuci sofa dan kasur. Ramah anak dan hewan peliharaan.',
        specialtyIds: {'clean-sofa', 'clean-mattress'},
        areas: {'Depok'},
        visitRate: 80000,
        ratingCount: 74,
        ratingSum: 340.4,
        jobsDone: 74,
        workHours: [
          for (var i = 0; i < 5; i++) const DayHours(9 * 60, 17 * 60),
          const DayHours(9 * 60, 13 * 60),
          const DayHours.closed(),
        ],
        portfolio: [
          _p('clean-sofa', 'Sofa kulit ruang tamu'),
          _p('clean-mattress', 'Kasur anak, tungau hilang', video: 17),
        ],
        reviews: [
          _r('Rani', 5, 'Aman untuk anak, kasur jadi wangi.', '4 hari lalu'),
          _r('Doni', 4, 'Rapi dan sopan.', '3 minggu lalu'),
        ],
      ),
      WorkerProfile(
        id: 'w_budi',
        name: 'Budi Hartono',
        gender: Gender.male,
        age: 41,
        bio:
            'Tukang pipa berpengalaman: bocor, mampet, pasang kran dan toilet.',
        specialtyIds: {'plumb-leak', 'plumb-clog', 'plumb-tap'},
        areas: {'Depok', 'Bekasi'},
        visitRate: 100000,
        ratingCount: 93,
        ratingSum: 427.8,
        jobsDone: 93,
        workHours: [
          for (var i = 0; i < 6; i++) const DayHours(7 * 60, 19 * 60),
          const DayHours(8 * 60, 12 * 60),
        ],
        portfolio: [
          _p('plumb-leak', 'Ganti pipa bocor di dapur'),
          _p('plumb-clog', 'Bongkar saluran wastafel mampet', video: 36),
          _p('plumb-tap', 'Pasang kran wudhu'),
        ],
        reviews: [
          _r('Hana', 5, 'Pipa bocor beres dalam satu jam.', '2 hari lalu'),
          _r('Eko', 4, 'Kerja bagus, harga sesuai.', '10 hari lalu'),
        ],
      ),
      WorkerProfile(
        id: 'w_dewi',
        name: 'Dewi Kurnia',
        gender: Gender.female,
        age: 31,
        bio:
            'Teknisi listrik bersertifikat. Instalasi aman dan sesuai standar.',
        specialtyIds: {'elec-outlet', 'elec-lamp', 'elec-short'},
        areas: {'Bekasi'},
        visitRate: 105000,
        ratingCount: 58,
        ratingSum: 272.6,
        jobsDone: 58,
        portfolio: [
          _p('elec-outlet', 'Tambah stopkontak dapur'),
          _p('elec-lamp', 'Pasang lampu gantung ruang makan', video: 22),
          _p('elec-short', 'Cari dan perbaiki korsleting MCB'),
        ],
        reviews: [
          _r(
            'Wulan',
            5,
            'Teliti dan menjelaskan risiko listriknya.',
            '3 hari lalu',
          ),
          _r('Imam', 4, 'Rapi, tapi jadwalnya padat.', '2 minggu lalu'),
        ],
      ),
      WorkerProfile(
        id: 'w_andi',
        name: 'Andi Pratama',
        gender: Gender.male,
        age: 24,
        bio: 'Servis laptop dan PC, serta ganti aki mobil langsung di tempat.',
        specialtyIds: {'gen-computer', 'gen-battery'},
        areas: {'Depok'},
        visitRate: 70000,
        ratingCount: 36,
        ratingSum: 162,
        jobsDone: 36,
        workHours: List.filled(7, const DayHours(10 * 60, 21 * 60)),
        portfolio: [
          _p('gen-computer', 'Upgrade SSD laptop lama'),
          _p('gen-battery', 'Ganti aki mobil di parkiran', video: 28),
        ],
        reviews: [
          _r('Reza', 5, 'Laptop jadi ngebut lagi.', '5 hari lalu'),
          _r('Salsa', 4, 'Aki diganti cepat.', '3 minggu lalu'),
        ],
      ),
      WorkerProfile(
        id: 'w_joko',
        name: 'Joko Susilo',
        gender: Gender.male,
        age: 52,
        bio: 'Cat dinding, plafon, dan rakit furnitur. Hasil halus dan rapi.',
        specialtyIds: {'paint-wall', 'paint-ceiling', 'gen-furniture'},
        areas: {'Bekasi'},
        visitRate: 150000,
        ratingCount: 29,
        ratingSum: 124.7,
        jobsDone: 29,
        portfolio: [
          _p('paint-wall', 'Cat ulang ruang tamu 4x5 m'),
          _p('paint-ceiling', 'Perbaiki dan cat plafon bocor'),
          _p('gen-furniture', 'Rakit lemari pakaian 3 pintu', video: 45),
        ],
        reviews: [
          _r(
            'Lina',
            4,
            'Hasil cat halus, selesai sesuai jadwal.',
            '1 minggu lalu',
          ),
          _r('Agung', 5, 'Furnitur dirakit kokoh.', '1 bulan lalu'),
        ],
      ),
      WorkerProfile(
        id: 'w_rina',
        name: 'Rina Kartika',
        gender: Gender.female,
        age: 27,
        bio: 'Servis kulkas dan mesin cuci semua merek.',
        specialtyIds: {'gen-fridge', 'gen-washer'},
        areas: {'Depok'},
        visitRate: 95000,
        ratingCount: 41,
        ratingSum: 200.9,
        jobsDone: 41,
        portfolio: [
          _p('gen-fridge', 'Ganti kompresor kulkas 2 pintu'),
          _p('gen-washer', 'Perbaiki mesin cuci tidak berputar', video: 31),
        ],
        reviews: [
          _r(
            'Tari',
            5,
            'Kulkas dingin lagi, penjelasannya jelas.',
            '2 hari lalu',
          ),
          _r(
            'Bima',
            5,
            'Mesin cuci normal lagi, harga wajar.',
            '2 minggu lalu',
          ),
        ],
      ),
    ];
  }
}
