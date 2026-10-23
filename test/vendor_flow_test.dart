import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fixit/theme.dart';
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
    await tester.pumpWidget(wrap(const VendorProfileScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Rekening bank'), findsWidgets);
  });

  testWidgets('vendor messages list renders clients', (tester) async {
    await tester.pumpWidget(wrap(const VendorMessagesScreen()));
    await tester.pumpAndSettle();
    // Unique client names from the vendor's jobs appear as chat targets.
    expect(find.text('Sinta'), findsWidgets);
    expect(find.text('Pesan'), findsOneWidget);
  });
}
