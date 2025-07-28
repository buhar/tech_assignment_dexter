import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shift_handover_challenge/features/shift_handover/bloc/shift_handover_bloc.dart';

class SubmitDialog extends StatefulWidget {
  const SubmitDialog({Key? key}) : super(key: key);

  @override
  State<SubmitDialog> createState() => _SubmitDialogState();
}

class _SubmitDialogState extends State<SubmitDialog> {
  final TextEditingController _summaryController = TextEditingController();

  @override
  void dispose() {
    _summaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Finalize and Submit Report'),
      content: TextField(
        controller: _summaryController,
        maxLines: 3,
        decoration: const InputDecoration(hintText: "Enter a brief shift summary..."),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            context.read<ShiftHandoverBloc>().add(
              SubmitReportRequested(summary: _summaryController.text)
            );
            Navigator.pop(context);
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
} 