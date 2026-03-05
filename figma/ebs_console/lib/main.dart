import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme/ebs_theme.dart';
import 'screens/console_screen.dart';

void main() {
  runApp(const ProviderScope(child: EbsConsoleApp()));
}

class EbsConsoleApp extends StatelessWidget {
  const EbsConsoleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EBS Console',
      debugShowCheckedModeBanner: false,
      theme: EbsTheme.dark,
      home: const ConsoleScreen(),
    );
  }
}
