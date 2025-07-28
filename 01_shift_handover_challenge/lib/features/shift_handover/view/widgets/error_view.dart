import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shift_handover_challenge/features/shift_handover/bloc/shift_handover_bloc.dart';

class ErrorView extends StatelessWidget {
  final String message;

  const ErrorView({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Failed to load shift report: $message', 
               style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
            onPressed: () => context
                .read<ShiftHandoverBloc>()
                .add(const LoadShiftReportRequested(caregiverId: 'current-user-id')),
          )
        ],
      ),
    );
  }
} 