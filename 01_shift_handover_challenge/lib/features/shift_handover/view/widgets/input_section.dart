import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shift_handover_challenge/features/shift_handover/bloc/shift_handover_bloc.dart';
import 'package:shift_handover_repository/shift_handover_repository.dart';

import 'submit_dialog.dart';

class InputSection extends StatefulWidget {
  final ShiftHandoverState state;

  const InputSection({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  State<InputSection> createState() => _InputSectionState();
}

class _InputSectionState extends State<InputSection> {
  final TextEditingController _textController = TextEditingController();
  NoteType _selectedType = NoteType.observation;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  bool get _isSubmitting {
    return widget.state is ShiftHandoverLoading &&
        (widget.state as ShiftHandoverLoading).type == LoadingType.submittingReport;
  }

  bool get _isAddingNote {
    return widget.state is ShiftHandoverLoading &&
        (widget.state as ShiftHandoverLoading).type == LoadingType.addingNote;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8.0,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Add a new note for the next shift...',
                suffixIcon: IconButton(
                  icon: _isAddingNote 
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.check),
                  onPressed: _isAddingNote ? null : () {
                    final text = _textController.text.trim();
                    if (text.isNotEmpty) {
                      context
                          .read<ShiftHandoverBloc>()
                          .add(AddNoteRequested(text: text, type: _selectedType));
                      _textController.clear();
                    }
                  },
                ),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  context
                      .read<ShiftHandoverBloc>()
                      .add(AddNoteRequested(text: value, type: _selectedType));
                  _textController.clear();
                }
              },
            ),
            const SizedBox(height: 12),
            NoteTypeDropdown(
              selectedType: _selectedType,
              onChanged: (type) {
                setState(() {
                  _selectedType = type;
                });
              },
            ),
            const SizedBox(height: 16),
            SubmitButton(isSubmitting: _isSubmitting),
          ],
        ),
      ),
    );
  }
}

class NoteTypeDropdown extends StatelessWidget {
  final NoteType selectedType;
  final ValueChanged<NoteType> onChanged;

  const NoteTypeDropdown({
    Key? key,
    required this.selectedType,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: const Color(0xFFBDBDBD)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<NoteType>(
          value: selectedType,
          isExpanded: true,
          icon: const Icon(Icons.category_outlined),
          onChanged: (NoteType? newValue) {
            if (newValue != null) {
              onChanged(newValue);
            }
          },
          items: NoteType.values.map((NoteType type) {
            return DropdownMenuItem<NoteType>(
              value: type,
              child: Text(type.name.toUpperCase()),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class SubmitButton extends StatelessWidget {
  final bool isSubmitting;

  const SubmitButton({
    Key? key,
    required this.isSubmitting,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: isSubmitting ? const SizedBox.shrink() : const Icon(Icons.send),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 52),
      ),
      onPressed: isSubmitting
          ? null
          : () {
              showDialog(
                context: context,
                builder: (dialogContext) => BlocProvider.value(
                  value: context.read<ShiftHandoverBloc>(),
                  child: const SubmitDialog(),
                ),
              );
            },
      label: isSubmitting
          ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: Colors.white,
              ))
          : const Text('Submit Final Report'),
    );
  }
}
