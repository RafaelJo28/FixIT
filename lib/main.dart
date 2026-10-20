import 'package:flutter/material.dart';

import 'screens/root_shell.dart';
import 'theme.dart';

void main() {
  runApp(const FixITApp());
}

/// Root application widget for the FixIT customer app.
class FixITApp extends StatelessWidget {
  const FixITApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FixIT',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const RootShell(),
    );
  }
}
