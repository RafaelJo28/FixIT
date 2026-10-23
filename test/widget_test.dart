import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fixit/auth/welcome_screen.dart';
import 'package:fixit/main.dart';
import 'package:fixit/screens/all_services_screen.dart';
import 'package:fixit/screens/profile_screen.dart';

Finder navLabel(String label) => find.descendant(
  of: find.byType(BottomNavigationBar),
  matching: find.text(label),
);

int currentTab(WidgetTester tester) => tester
    .widget<BottomNavigationBar>(find.byType(BottomNavigationBar))
    .currentIndex;

/// Signs in as a customer through the demo OTP code.
Future<void> signInAsCustomer(WidgetTester tester) async {
  await tester.pumpWidget(const FixITApp());

  await tester.tap(find.text('Saya butuh tukang'));
  await tester.pumpAndSettle();

  await tester.enterText(find.byType(TextField).first, '8123456789');
  await tester.pumpAndSettle();

  await tester.tap(find.text('Kirim kode via WhatsApp'));
  await tester.pumpAndSettle();

  await tester.enterText(find.byType(TextField).first, '123456');
  await tester.pumpAndSettle();

  await tester.tap(find.text('Verifikasi'));
  await tester.pumpAndSettle();
}

void main() {
  group('role selection', () {
    testWidgets('app starts on the welcome screen', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const FixITApp());

      expect(find.byType(WelcomeScreen), findsOneWidget);
      expect(find.text('Selamat datang!'), findsOneWidget);
      expect(find.text('Saya butuh tukang'), findsOneWidget);
      expect(find.text('Saya tukang / mitra'), findsOneWidget);
    });

    testWidgets('customer role opens the phone screen', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const FixITApp());

      await tester.tap(find.text('Saya butuh tukang'));
      await tester.pumpAndSettle();

      expect(find.text('Masuk dengan nomor WhatsApp'), findsOneWidget);
    });

    testWidgets('vendor role opens the phone screen', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const FixITApp());

      await tester.tap(find.text('Saya tukang / mitra'));
      await tester.pumpAndSettle();

      expect(find.text('Masuk sebagai mitra'), findsOneWidget);
    });
  });

  group('sign in', () {
    testWidgets('customer signs in and reaches the customer app', (
      WidgetTester tester,
    ) async {
      await signInAsCustomer(tester);

      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(navLabel('Beranda'), findsOneWidget);
      expect(navLabel('Transaksi'), findsOneWidget);
      expect(navLabel('Pesan'), findsOneWidget);
      expect(navLabel('Fixie'), findsOneWidget);
    });

    testWidgets('vendor signs in and reaches the vendor onboarding', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const FixITApp());

      await tester.tap(find.text('Saya tukang / mitra'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, '8123456789');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Kirim kode via WhatsApp'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, '123456');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Verifikasi'));
      await tester.pumpAndSettle();

      expect(find.text('Jadi mitra FixIT'), findsOneWidget);
    });
  });

  group('customer app', () {
    testWidgets('navigates the bottom navigation tabs', (
      WidgetTester tester,
    ) async {
      await signInAsCustomer(tester);

      await tester.tap(navLabel('Transaksi'));
      await tester.pumpAndSettle();
      expect(find.text('Pesanan Saya'), findsOneWidget);

      await tester.tap(navLabel('Pesan'));
      await tester.pumpAndSettle();
      expect(currentTab(tester), 2);

      await tester.tap(navLabel('Fixie'));
      await tester.pumpAndSettle();
      expect(currentTab(tester), 3);
    });

    testWidgets('home screen renders core content', (
      WidgetTester tester,
    ) async {
      await signInAsCustomer(tester);

      expect(find.text('Mau perbaiki apa\nhari ini?'), findsOneWidget);
      expect(find.text('Cari servis AC, listrik, pipa...'), findsOneWidget);

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

    testWidgets(
      'profile opens from the home header and logout returns to welcome',
      (WidgetTester tester) async {
        await signInAsCustomer(tester);

        await tester.tap(find.byIcon(Icons.account_circle_rounded));
        await tester.pumpAndSettle();
        expect(find.text('Joel Pratama'), findsOneWidget);

        final logoutItem = find.descendant(
          of: find.byType(ProfileScreen),
          matching: find.text('Keluar'),
        );
        await tester.ensureVisible(logoutItem);
        await tester.pumpAndSettle();
        await tester.tap(logoutItem);
        await tester.pumpAndSettle();

        await tester.tap(find.widgetWithText(TextButton, 'Keluar'));
        await tester.pumpAndSettle();

        expect(find.byType(WelcomeScreen), findsOneWidget);
      },
    );

    testWidgets('Lihat semua opens the full service list', (
      WidgetTester tester,
    ) async {
      await signInAsCustomer(tester);

      await tester.scrollUntilVisible(
        find.text('Lihat semua'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Lihat semua'));
      await tester.pumpAndSettle();

      expect(find.byType(AllServicesScreen), findsOneWidget);
    });

    testWidgets('Fixie has no back button and shows sent messages', (
      WidgetTester tester,
    ) async {
      await signInAsCustomer(tester);

      await tester.tap(navLabel('Fixie'));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.arrow_back_rounded), findsNothing);

      await tester.enterText(
        find.byType(TextField).last,
        'AC kamar kurang dingin',
      );
      await tester.pump();
      await tester.tap(find.byIcon(Icons.send_rounded).last);
      await tester.pumpAndSettle();

      expect(find.text('AC kamar kurang dingin'), findsOneWidget);
      expect(find.textContaining('hanya contoh'), findsOneWidget);
    });
  });
}
