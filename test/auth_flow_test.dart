import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fixit/auth/otp_screen.dart';
import 'package:fixit/auth/phone_screen.dart';
import 'package:fixit/auth/user_role.dart';
import 'package:fixit/screens/root_shell.dart';
import 'package:fixit/vendor/vendor_apply_screen.dart';

void main() {
  testWidgets('customer phone -> otp -> RootShell', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: PhoneScreen(role: UserRole.customer)),
    );
    await tester.enterText(find.byType(TextField), '81234567890');
    await tester.pump();
    await tester.tap(find.text('Kirim kode via WhatsApp'));
    await tester.pumpAndSettle();
    expect(find.text('Masukkan kode verifikasi'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '123456');
    await tester.pump();
    await tester.tap(find.text('Verifikasi'));
    await tester.pumpAndSettle();
    expect(find.byType(RootShell), findsOneWidget);
  });

  testWidgets('wrong otp shows error', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: OtpScreen(role: UserRole.customer, phone: '+6281'),
      ),
    );
    await tester.enterText(find.byType(TextField), '999999');
    await tester.pump();
    await tester.tap(find.text('Verifikasi'));
    await tester.pump();
    expect(find.text('Kode salah. Coba lagi.'), findsOneWidget);
  });

  testWidgets('vendor otp -> VendorApplyScreen', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: OtpScreen(role: UserRole.vendor, phone: '+6281'),
      ),
    );
    await tester.enterText(find.byType(TextField), '123456');
    await tester.pump();
    await tester.tap(find.text('Verifikasi'));
    await tester.pumpAndSettle();
    expect(find.byType(VendorApplyScreen), findsOneWidget);
  });
}
