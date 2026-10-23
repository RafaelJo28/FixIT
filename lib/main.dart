import 'package:flutter/material.dart';

import 'auth/welcome_screen.dart';
import 'theme.dart';

void main() {
  runApp(const FixITApp());
}

/// Root application widget for FixIT.
///
/// The app starts on the role-selection screen: the customer and the vendor
/// each sign in through their own flow and land in their own app.
class FixITApp extends StatelessWidget {
  const FixITApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FixIT',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const WelcomeScreen(),
    );
  }
}
