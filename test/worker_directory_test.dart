import 'package:flutter_test/flutter_test.dart';

import 'package:fixit/data/worker_directory.dart';
import 'package:fixit/models/worker_profile.dart';

void main() {
  final dir = WorkerDirectory.instance;
  setUp(dir.reset);

  test('every seeded worker has proof of work for each specialty', () {
    for (final w in dir.all) {
      expect(w.hasProofForAllSpecialties, isTrue, reason: w.name);
    }
  });

  test('rating is the average and updates after a new review', () {
    final w = dir.byId('w_agus')!;
    final sum = w.ratingSum;
    final count = w.ratingCount;
    expect(w.rating, closeTo(4.4, 0.001));

    dir.addReview('w_agus', customerName: 'Tes', rating: 5, comment: 'Mantap');
    expect(w.ratingCount, count + 1);
    expect(w.rating, closeTo((sum + 5) / (count + 1), 1e-9));
    expect(w.reviews.first.customerName, 'Tes');
  });

  test('text search matches name, specialty, category and area', () {
    final ac = dir
        .search(const WorkerFilter(query: 'cuci ac'))
        .map((w) => w.id);
    expect(ac, contains('me'));
    expect(ac, contains('w_rudi'));
    expect(ac, isNot(contains('w_budi')));

    final byName = dir.search(const WorkerFilter(query: 'siti'));
    expect(byName.single.id, 'w_siti');

    final plumbing = dir.search(const WorkerFilter(query: 'pipa'));
    expect(plumbing.map((w) => w.id), contains('w_budi'));
  });

  test('gender filter', () {
    final women = dir.search(const WorkerFilter(gender: Gender.female));
    expect(women, isNotEmpty);
    expect(women.every((w) => w.gender == Gender.female), isTrue);
  });

  test('age range filter', () {
    final r = dir.search(const WorkerFilter(minAge: 40, maxAge: 50));
    expect(r, isNotEmpty);
    expect(r.every((w) => w.age >= 40 && w.age <= 50), isTrue);
  });

  test('rating range filter', () {
    final r = dir.search(const WorkerFilter(minRating: 4.7));
    expect(r, isNotEmpty);
    expect(r.every((w) => w.rating >= 4.7), isTrue);

    final low = dir.search(const WorkerFilter(maxRating: 4.5));
    expect(low.every((w) => w.rating <= 4.5), isTrue);
  });

  test('price range filter uses the visit rate', () {
    final r = dir.search(const WorkerFilter(minPrice: 80000, maxPrice: 100000));
    expect(r, isNotEmpty);
    expect(
      r.every(
        (w) =>
            w.visitRate != null &&
            w.visitRate! >= 80000 &&
            w.visitRate! <= 100000,
      ),
      isTrue,
    );
  });

  test('workers without a negotiated rate remain discoverable', () {
    dir.updateMe((worker) => worker.visitRate = null);

    expect(dir.search(const WorkerFilter()).map((w) => w.id), contains('me'));
    expect(
      dir
          .search(const WorkerFilter(minPrice: 80000, maxPrice: 100000))
          .map((w) => w.id),
      isNot(contains('me')),
    );
    expect(
      dir.search(const WorkerFilter(sort: WorkerSort.priceLow)).last.id,
      'me',
    );
  });

  test('category and specialty filters', () {
    final plumbing = dir.search(const WorkerFilter(categoryId: 'plumbing'));
    expect(plumbing.map((w) => w.id), ['w_budi']);

    final battery = dir.search(const WorkerFilter(specialtyId: 'gen-battery'));
    expect(battery.map((w) => w.id), ['w_andi']);
  });

  test('sorting', () {
    final cheap = dir.search(const WorkerFilter(sort: WorkerSort.priceLow));
    for (var i = 1; i < cheap.length; i++) {
      expect(cheap[i - 1].visitRate! <= cheap[i].visitRate!, isTrue);
    }
    final best = dir.search(const WorkerFilter());
    for (var i = 1; i < best.length; i++) {
      expect(best[i - 1].rating >= best[i].rating, isTrue);
    }
  });

  test('combined filters narrow the list', () {
    final r = dir.search(
      const WorkerFilter(
        categoryId: 'cleaning',
        gender: Gender.female,
        maxPrice: 85000,
      ),
    );
    expect(r.map((w) => w.id), ['w_maya']);
  });

  test('unverified workers are not listed for customers', () {
    dir.updateMe((m) => m.verified = false);
    expect(dir.search(const WorkerFilter()).any((w) => w.id == 'me'), isFalse);
    dir.updateMe((m) => m.verified = true);
    expect(dir.search(const WorkerFilter()).any((w) => w.id == 'me'), isTrue);
  });

  test('work hours validation', () {
    expect(validWorkHours(defaultWorkHours()), isTrue);
    expect(validWorkHours(List.filled(7, const DayHours.closed())), isFalse);
    expect(
      validWorkHours([
        const DayHours(17 * 60, 8 * 60),
        ...defaultWorkHours().skip(1),
      ]),
      isFalse,
    );
  });

  test('filter activeCount counts changed filters', () {
    expect(const WorkerFilter().activeCount, 0);
    expect(
      const WorkerFilter(gender: Gender.male, minRating: 4).activeCount,
      2,
    );
  });
}
