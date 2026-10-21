import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fixit/main.dart';

Finder navLabel(String label) => find.descendant(
  of: find.byType(BottomNavigationBar),
  matching: find.text(label),
);

int currentTab(WidgetTester tester) =>
    tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar)).currentIndex;

void main() {
  testWidgets('FixIT home screen renders core UI', (WidgetTester tester) async {
    await tester.pumpWidget(const FixITApp());

    // Brand + location header (above the fold)
    expect(find.text('FixIT'), findsOneWidget);
    expect(find.text('Depok / Bekasi'), findsOneWidget);

    // Active order card sits just under the search bar.
    expect(find.text('Pesanan aktif'), findsOneWidget);

    // Bottom navigation tabs (always visible)
    expect(navLabel('Beranda'), findsOneWidget);
    expect(navLabel('Pesanan'), findsOneWidget);
    expect(navLabel('Pesan'), findsOneWidget);
    expect(navLabel('Profil'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Layanan Populer'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Layanan Populer'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Kata Pelanggan'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Kata Pelanggan'), findsOneWidget);
  });

  testWidgets('navigates Beranda -> Pesanan -> Profil tabs', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const FixITApp());

    await tester.tap(navLabel('Pesanan'));
    await tester.pumpAndSettle();
    expect(find.text('Pesanan Saya'), findsOneWidget);

    await tester.tap(navLabel('Profil'));
    await tester.pumpAndSettle();
    expect(find.text('Joel Pratama'), findsOneWidget);
  });

  testWidgets('active order card switches to the Pesanan tab', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const FixITApp());
    expect(currentTab(tester), 0);

    await tester.ensureVisible(find.text('Pesanan aktif'));
    await tester.tap(find.text('Pesanan aktif'));
    await tester.pumpAndSettle();

    expect(currentTab(tester), 1);
  });

  testWidgets('profile button switches to the Profil tab', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const FixITApp());
    expect(currentTab(tester), 0);

    await tester.tap(find.byIcon(Icons.account_circle_rounded));
    await tester.pumpAndSettle();

    expect(currentTab(tester), 3);
  });
}
