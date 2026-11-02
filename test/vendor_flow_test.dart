import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fixit/data/worker_directory.dart';
import 'package:fixit/theme.dart';
import 'package:fixit/vendor/portfolio_editor.dart';
import 'package:fixit/vendor/vendor_earnings_screen.dart';
import 'package:fixit/vendor/vendor_home_screen.dart';
import 'package:fixit/vendor/vendor_job_detail_screen.dart';
import 'package:fixit/vendor/vendor_messages_screen.dart';
import 'package:fixit/vendor/vendor_profile_screen.dart';
import 'package:fixit/vendor/vendor_store.dart';

Widget wrap(Widget child) => MaterialApp(theme: AppTheme.light(), home: child);

void main() {
  testWidgets('vendor home renders', (tester) async {
    await tester.pumpWidget(wrap(VendorHomeScreen(onOpenJobs: () {})));
    await tester.pumpAndSettle();
    expect(find.text('Halo, Pak Hendra'), findsOneWidget);
    expect(find.text('Siap menerima pekerjaan'), findsOneWidget);
  });

  testWidgets('vendor job detail renders', (tester) async {
    final job = VendorStore.instance.jobs.first;
    await tester.pumpWidget(wrap(VendorJobDetailScreen(job: job)));
    await tester.pumpAndSettle();
    expect(find.text('Detail Pekerjaan'), findsOneWidget);
  });

  testWidgets('vendor earnings renders', (tester) async {
    await tester.pumpWidget(wrap(const VendorEarningsScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Saldo tersedia'), findsOneWidget);
  });

  testWidgets('vendor profile renders', (tester) async {
    tester.view.physicalSize = const Size(800, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(wrap(const VendorProfileScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Rekening bank'), findsWidgets);
    expect(find.text('Profil publik'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Profil publik'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Profil publik'));
    await tester.pumpAndSettle();
    expect(find.byType(VendorPortfolioScreen), findsOneWidget);
    expect(find.text('Tentang saya'), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller?.text,
      WorkerDirectory.instance.me.bio,
    );
  });

  testWidgets('vendor messages list renders clients', (tester) async {
    await tester.pumpWidget(wrap(const VendorMessagesScreen()));
    await tester.pumpAndSettle();
    // Unique client names from the vendor's jobs appear as chat targets.
    expect(find.text('Sinta'), findsWidgets);
    expect(find.text('Pesan'), findsOneWidget);
  });
}
