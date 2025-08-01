import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shift_handover_api/shift_handover_api.dart';
import 'package:shift_handover_repository/shift_handover_repository.dart';
import 'package:shift_handover_challenge/app/theme/theme.dart';
import 'package:shift_handover_challenge/features/shift_handover/view/shift_handover_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ShiftHandoverApiClient>(
          create: (context) => ShiftHandoverApiClient(),
        ),
        RepositoryProvider<InMemoryShiftHandoverStorage>(
          create: (context) => InMemoryShiftHandoverStorage(),
        ),
        RepositoryProvider<ShiftHandoverRepository>(
          create: (context) => ShiftHandoverRepositoryImpl(
            apiClient: context.read<ShiftHandoverApiClient>(),
            storage: context.read<InMemoryShiftHandoverStorage>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Shift Handover',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const ShiftHandoverScreen(),
      ),
    );
  }
}