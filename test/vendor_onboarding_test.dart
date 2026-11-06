import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fixit/data/worker_directory.dart';
import 'package:fixit/theme.dart';
import 'package:fixit/vendor/portfolio_editor.dart';
import 'package:fixit/vendor/vendor_apply_screen.dart';
import 'package:fixit/vendor/vendor_shell.dart';
import 'package:fixit/vendor/work_hours_editor.dart';

Widget wrap(Widget child) => MaterialApp(theme: AppTheme.light(), home: child);

void main() {
  final dir = WorkerDirectory.instance;
  setUp(dir.reset);

  testWidgets('work hours can be edited and saved', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(wrap(const WorkHoursScreen()));
    expect(dir.me.workHours[6].isOpen, isFalse);

    final sunday = find.byType(Switch).at(6);
    await tester.scrollUntilVisible(
      sunday,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(sunday, warnIfMissed: false);
    await tester.pump();

    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();

    expect(dir.me.workHours[6].isOpen, isTrue);
  });

  testWidgets('vendor can add and remove portfolio items', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(wrap(const VendorPortfolioScreen()));
    final before = dir.me.portfolio.length;

    await tester.tap(find.text('Tambah foto'));
    await tester.pumpAndSettle();

    final sheet = find.byType(BottomSheet);
    await tester.tap(
      find.descendant(of: sheet, matching: find.text('Isi Freon')),
    );
    await tester.pump();
    await tester.tap(find.text('Pilih foto dari galeri'));
    await tester.pump();
    await tester.enterText(
      find.descendant(of: sheet, matching: find.byType(TextField)),
      'Isi freon AC 2 PK',
    );
    await tester.pump();
    await tester.ensureVisible(find.text('Tambahkan'));
    await tester.tap(find.text('Tambahkan'));
    await tester.pumpAndSettle();

    expect(dir.me.portfolio.length, before + 1);
    expect(dir.me.portfolio.last.caption, 'Isi freon AC 2 PK');
    expect(dir.me.portfolio.last.specialtyId, 'ac-freon');

    final close = find.byIcon(Icons.close_rounded).first;
    await tester.ensureVisible(close);
    await tester.tap(close);
    await tester.pumpAndSettle();
    expect(dir.me.portfolio.length, before);
  });

  testWidgets('vendor can edit public bio and existing portfolio items', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(wrap(const VendorPortfolioScreen()));
    final original = dir.me.portfolio.first;

    await tester.enterText(
      find.byType(TextField).first,
      'Teknisi berpengalaman',
    );
    await tester.tap(find.text('Simpan deskripsi'));
    await tester.pumpAndSettle();
    tester
        .state<ScaffoldMessengerState>(find.byType(ScaffoldMessenger))
        .hideCurrentSnackBar();
    await tester.pumpAndSettle();
    expect(dir.me.bio, 'Teknisi berpengalaman');

    await tester.scrollUntilVisible(
      find.byIcon(Icons.edit_outlined).first,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byIcon(Icons.edit_outlined).first);
    await tester.pumpAndSettle();
    expect(find.text('Edit bukti pekerjaan'), findsOneWidget);

    await tester.tap(find.text('Ganti foto dari galeri'));
    await tester.pump();
    await tester.tap(find.text('Pilih foto dari galeri'));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'Foto hasil terbaru');
    await tester.pump();
    await tester.tap(find.text('Simpan perubahan'));
    await tester.pumpAndSettle();

    final edited = dir.me.portfolio.firstWhere(
      (item) => item.id == original.id,
    );
    expect(edited.caption, 'Foto hasil terbaru');
    expect(edited.specialtyId, original.specialtyId);
    expect(edited.isVideo, original.isVideo);
  });

  testWidgets('registration needs proof for each specialty, then submits', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(wrap(const VendorApplyScreen()));

    ElevatedButton primary(String label) => tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, label),
    );

    // Step 1: personal data
    expect(find.text('Jadi mitra FixIT'), findsOneWidget);
    expect(primary('Lanjut').onPressed, isNull);
    await tester.enterText(find.byType(TextField).at(0), 'Joel Pratama');
    await tester.tap(find.text('Laki-laki'));
    await tester.pump();
    await tester.enterText(find.byType(TextField).at(1), '27');
    await tester.pump();
    expect(primary('Lanjut').onPressed, isNotNull);
    await tester.tap(find.text('Lanjut'));
    await tester.pumpAndSettle();

    // Step 2: specialties and area
    await tester.tap(find.text('Cuci AC'));
    await tester.pump();
    await tester.scrollUntilVisible(
      find.text('Depok'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Depok'));
    await tester.pump();
    await tester.tap(find.text('Lanjut'));
    await tester.pumpAndSettle();

    // Step 3: hours only; the visit rate is negotiated with the customer later.
    expect(find.text('Tarif per kunjungan'), findsNothing);
    expect(find.byType(TextField), findsNothing);
    expect(primary('Lanjut').onPressed, isNotNull);
    await tester.tap(find.text('Lanjut'));
    await tester.pumpAndSettle();

    // Step 4: proof of work (required)
    expect(primary('Lanjut').onPressed, isNull);
    await tester.tap(find.text('Tambah foto'));
    await tester.pumpAndSettle();
    final sheet = find.byType(BottomSheet);
    await tester.tap(find.text('Pilih foto dari galeri'));
    await tester.pump();
    await tester.enterText(
      find.descendant(of: sheet, matching: find.byType(TextField)),
      'Cuci AC split di Depok',
    );
    await tester.pump();
    await tester.ensureVisible(find.text('Tambahkan'));
    await tester.tap(find.text('Tambahkan'));
    await tester.pumpAndSettle();
    expect(primary('Lanjut').onPressed, isNotNull);
    await tester.tap(find.text('Lanjut'));
    await tester.pumpAndSettle();

    // Step 5: documents
    expect(primary('Kirim pendaftaran').onPressed, isNull);
    await tester.tap(find.text('Foto KTP'));
    await tester.pump();
    await tester.tap(find.text('Foto selfie dengan KTP'));
    await tester.pump();
    await tester.tap(find.text('Kirim pendaftaran'));
    await tester.pumpAndSettle();

    expect(find.text('Pendaftaran terkirim'), findsOneWidget);
    expect(dir.me.name, 'Joel Pratama');
    expect(dir.me.visitRate, isNull);
    expect(dir.me.verified, isFalse);
    expect(dir.listed.any((w) => w.id == 'me'), isFalse);
    expect(dir.me.hasProofForAllSpecialties, isTrue);

    await tester.tap(find.text('Lihat dashboard (demo)'));
    await tester.pumpAndSettle();
    expect(find.byType(VendorShell), findsOneWidget);
    expect(find.text('Halo, Pak Joel'), findsOneWidget);
    expect(dir.me.verified, isTrue);
  });
}
