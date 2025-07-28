part of 'shift_handover_bloc.dart';

sealed class ShiftHandoverEvent extends Equatable {
  const ShiftHandoverEvent();
}

class LoadShiftReportRequested extends ShiftHandoverEvent {
  final String caregiverId;
  
  const LoadShiftReportRequested({required this.caregiverId});

  @override
  List<Object> get props => [caregiverId];
}

class AddNoteRequested extends ShiftHandoverEvent {
  final String text;
  final NoteType type;
  
  const AddNoteRequested({
    required this.text,
    required this.type,
  });

  @override
  List<Object> get props => [text, type];
}

class SubmitReportRequested extends ShiftHandoverEvent {
  final String summary;
  
  const SubmitReportRequested({required this.summary});

  @override
  List<Object> get props => [summary];
}

class RefreshReportRequested extends ShiftHandoverEvent {
  final String caregiverId;
  
  const RefreshReportRequested({required this.caregiverId});

  @override
  List<Object> get props => [caregiverId];
}