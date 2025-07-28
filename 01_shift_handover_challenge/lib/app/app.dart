import 'package:flutter/material.dart';
import 'package:shift_handover_challenge/app/theme/theme.dart';
import 'package:shift_handover_challenge/features/shift_handover/view/shift_handover_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shift Handover',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const ShiftHandoverScreen(),
    );
  }
}