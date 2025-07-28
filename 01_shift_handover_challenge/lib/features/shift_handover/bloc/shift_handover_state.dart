part of 'shift_handover_bloc.dart';

sealed class ShiftHandoverState extends Equatable {
  const ShiftHandoverState();
}

class ShiftHandoverInitial extends ShiftHandoverState {
  const ShiftHandoverInitial();

  @override
  List<Object?> get props => [];
}

class ShiftHandoverLoading extends ShiftHandoverState {
  final ShiftReport? report;
  final LoadingType type;

  const ShiftHandoverLoading({
    this.report, 
    required this.type,
  });

  @override
  List<Object?> get props => [report, type];
}

class ShiftHandoverSuccess extends ShiftHandoverState {
  final ShiftReport report;
  final SuccessType type;

  const ShiftHandoverSuccess({
    required this.report,
    required this.type,
  });

  @override
  List<Object?> get props => [report, type];
}

class ShiftHandoverError extends ShiftHandoverState {
  final String message;
  final ShiftReport? report;
  final ShiftHandoverException? exception;

  const ShiftHandoverError({
    required this.message,
    this.report,
    this.exception,
  });

  @override
  List<Object?> get props => [message, report, exception];
}

enum LoadingType {
  loadingReport,
  addingNote, 
  submittingReport,
}

enum SuccessType {
  reportLoaded,
  noteAdded,
  reportSubmitted,
}
