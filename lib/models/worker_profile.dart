/// Pure data models for worker (vendor) profiles. No Flutter imports.
///
/// PROTOTYPE ONLY: everything lives in memory (see WorkerDirectory). Later this
/// data comes from the backend, and verification is decided by the server.

enum Gender { male, female }

extension GenderX on Gender {
  String get label => this == Gender.male ? 'Laki-laki' : 'Perempuan';
}

const int kAgeMin = 18;
const int kAgeMax = 70;
const int kPriceMin = 0;
const int kPriceMax = 500000;

const List<String> kDayNames = [
  'Senin',
  'Selasa',
  'Rabu',
  'Kamis',
  'Jumat',
  'Sabtu',
  'Minggu',
];

const List<String> kAreas = ['Depok', 'Bekasi'];

/// 480 -> "08:00".
String formatMinutes(int m) {
  final h = (m ~/ 60).toString().padLeft(2, '0');
  final min = (m % 60).toString().padLeft(2, '0');
  return '$h:$min';
}

/// Opening hours for one day. Minutes after midnight; null means closed.
class DayHours {
  const DayHours(this.openMin, this.closeMin);
  const DayHours.closed() : openMin = null, closeMin = null;

  final int? openMin;
  final int? closeMin;

  bool get isOpen => openMin != null && closeMin != null;
  bool get isValid => !isOpen || openMin! < closeMin!;
  String get label => isOpen
      ? '${formatMinutes(openMin!)} - ${formatMinutes(closeMin!)}'
      : 'Libur';
}

/// Monday to Friday 08:00-17:00, Saturday 08:00-14:00, Sunday closed.
List<DayHours> defaultWorkHours() => [
  for (var i = 0; i < 5; i++) const DayHours(8 * 60, 17 * 60),
  const DayHours(8 * 60, 14 * 60),
  const DayHours.closed(),
];

bool validWorkHours(List<DayHours> hours) =>
    hours.every((h) => h.isValid) && hours.any((h) => h.isOpen);

/// One photo or video of past work, tagged with the specialty it proves.
/// The media itself is mocked for now (a colored tile).
class PortfolioItem {
  const PortfolioItem({
    required this.id,
    required this.specialtyId,
    required this.caption,
    this.isVideo = false,
    this.durationSec = 0,
    this.shade = 0,
  });

  final String id;
  final String specialtyId;
  final String caption;
  final bool isVideo;
  final int durationSec;

  /// 0-3, only used to vary the mock thumbnails.
  final int shade;

  String get durationLabel =>
      '${durationSec ~/ 60}:${(durationSec % 60).toString().padLeft(2, '0')}';
}

/// A rating (1-5 stars) a customer left after a finished job.
class Review {
  const Review({
    required this.customerName,
    required this.rating,
    required this.comment,
    required this.dateLabel,
    this.specialtyId,
  });

  final String customerName;
  final int rating;
  final String comment;
  final String dateLabel;
  final String? specialtyId;
}

class WorkerProfile {
  WorkerProfile({
    required this.id,
    required this.name,
    required this.gender,
    required this.age,
    this.bio = '',
    Set<String>? specialtyIds,
    Set<String>? areas,
    this.visitRate,
    List<DayHours>? workHours,
    List<PortfolioItem>? portfolio,
    List<Review>? reviews,
    this.ratingCount = 0,
    this.ratingSum = 0,
    this.jobsDone = 0,
    this.verified = true,
  }) : specialtyIds = specialtyIds ?? <String>{},
       areas = areas ?? <String>{},
       workHours = workHours ?? defaultWorkHours(),
       portfolio = portfolio ?? <PortfolioItem>[],
       reviews = reviews ?? <Review>[];

  final String id;
  String name;
  Gender gender;
  int age;
  String bio;
  Set<String> specialtyIds;
  Set<String> areas;

  /// Agreed visit price, or null until the worker and customer negotiate it.
  int? visitRate;
  List<DayHours> workHours;
  List<PortfolioItem> portfolio;
  List<Review> reviews;

  /// Every rating ever received (including ones older than [reviews]).
  int ratingCount;
  double ratingSum;
  int jobsDone;

  /// False while the account waits for approval. Unverified workers are not
  /// listed for customers.
  bool verified;

  double get rating => ratingCount == 0 ? 0 : ratingSum / ratingCount;
  String get honorific => gender == Gender.female ? 'Bu' : 'Pak';
  String get firstName => name.trim().split(' ').first;
  DayHours get today => workHours[DateTime.now().weekday - 1];

  int proofCount(String specialtyId) =>
      portfolio.where((p) => p.specialtyId == specialtyId).length;

  bool get hasProofForAllSpecialties =>
      specialtyIds.every((s) => proofCount(s) > 0);

  void addRating(int stars) {
    ratingSum += stars;
    ratingCount += 1;
  }
}
