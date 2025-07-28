import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shift_handover_challenge/features/shift_handover/bloc/shift_handover_bloc.dart';
import 'package:shift_handover_challenge/features/shift_handover/view/note_card.dart';
import 'package:shift_handover_challenge/features/shift_handover/view/widgets/error_view.dart';
import 'package:shift_handover_challenge/features/shift_handover/view/widgets/input_section.dart';
import 'package:shift_handover_repository/shift_handover_repository.dart';

class ShiftHandoverScreen extends StatelessWidget {
  const ShiftHandoverScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShiftHandoverBloc(
        repository: context.read<ShiftHandoverRepository>(),
      )..add(const LoadShiftReportRequested(caregiverId: 'current-user-id')),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Shift Handover Report'),
          elevation: 0,
          actions: [
            BlocBuilder<ShiftHandoverBloc, ShiftHandoverState>(
              builder: (context, state) {
                if (state is ShiftHandoverLoading && state.report == null) {
                  return const SizedBox.shrink();
                }
                return IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Refresh Report',
                  onPressed: () {
                    context
                        .read<ShiftHandoverBloc>()
                        .add(const RefreshReportRequested(caregiverId: 'current-user-id'));
                  },
                );
              },
            ),
          ],
        ),
        body: BlocConsumer<ShiftHandoverBloc, ShiftHandoverState>(
          listener: (context, state) {
            if (state is ShiftHandoverError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('An error occurred: ${state.message}'),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            }
            if (state is ShiftHandoverSuccess && state.type == SuccessType.reportSubmitted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Report submitted successfully!'),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
              );
            }
          },
          builder: (context, state) {
            return switch (state) {
              ShiftHandoverInitial() => const Center(child: CircularProgressIndicator()),
              ShiftHandoverLoading(report: null) =>
                const Center(child: CircularProgressIndicator()),
              ShiftHandoverLoading(:final report?) => ReportView(report: report, state: state),
              ShiftHandoverSuccess(:final report) => ReportView(report: report, state: state),
              ShiftHandoverError(report: null, :final message) => ErrorView(message: message),
              ShiftHandoverError(:final report?) => ReportView(report: report, state: state),
            };
          },
        ),
      ),
    );
  }
}

class ReportView extends StatelessWidget {
  final ShiftReport report;
  final ShiftHandoverState state;

  const ReportView({
    Key? key,
    required this.report,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (report.notes.isEmpty)
          const Expanded(child: EmptyNotesView())
        else
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16.0),
              itemCount: report.notes.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return NoteCard(note: report.notes[index]);
              },
            ),
          ),
        InputSection(state: state),
      ],
    );
  }
}

class EmptyNotesView extends StatelessWidget {
  const EmptyNotesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'No notes added yet.\nUse the form below to add the first note.',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
      ),
    );
  }
}
