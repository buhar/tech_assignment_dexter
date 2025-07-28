import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:shift_handover_repository/shift_handover_repository.dart';

part 'shift_handover_event.dart';
part 'shift_handover_state.dart';

class ShiftHandoverBloc extends Bloc<ShiftHandoverEvent, ShiftHandoverState> {
  final ShiftHandoverRepository _repository;

  ShiftHandoverBloc({
    required ShiftHandoverRepository repository,
  }) : _repository = repository,
       super(const ShiftHandoverInitial()) {
    on<LoadShiftReportRequested>(_onLoadShiftReportRequested);
    on<AddNoteRequested>(_onAddNoteRequested);
    on<SubmitReportRequested>(_onSubmitReportRequested);
    on<RefreshReportRequested>(_onRefreshReportRequested);
  }

  Future<void> _onLoadShiftReportRequested(
    LoadShiftReportRequested event,
    Emitter<ShiftHandoverState> emit,
  ) async {
    emit(const ShiftHandoverLoading(type: LoadingType.loadingReport));
    try {
      final report = await _repository.getShiftReport(event.caregiverId);
      emit(ShiftHandoverSuccess(
        report: report,
        type: SuccessType.reportLoaded,
      ));
    } catch (e) {
      final exception = e is ShiftHandoverException ? e : null;
      emit(ShiftHandoverError(
        message: exception?.message ?? e.toString(),
        exception: exception,
      ));
    }
  }

  Future<void> _onAddNoteRequested(
    AddNoteRequested event,
    Emitter<ShiftHandoverState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ShiftHandoverSuccess) return;

    emit(ShiftHandoverLoading(
      report: currentState.report,
      type: LoadingType.addingNote,
    ));
    
    try {
      final newNote = HandoverNote(
        id: 'note-${DateTime.now().millisecondsSinceEpoch}',
        text: event.text,
        type: event.type,
        timestamp: DateTime.now(),
        authorId: currentState.report.caregiverId,
      );

      await _repository.addNote(currentState.report.id, newNote);
      
      final updatedNotes = List<HandoverNote>.from(currentState.report.notes)..add(newNote);
      final updatedReport = currentState.report.copyWith(notes: updatedNotes);
      
      emit(ShiftHandoverSuccess(
        report: updatedReport,
        type: SuccessType.noteAdded,
      ));
    } catch (e) {
      final exception = e is ShiftHandoverException ? e : null;
      emit(ShiftHandoverError(
        message: exception?.message ?? e.toString(),
        report: currentState.report,
        exception: exception,
      ));
    }
  }

  Future<void> _onSubmitReportRequested(
    SubmitReportRequested event,
    Emitter<ShiftHandoverState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ShiftHandoverSuccess) return;

    emit(ShiftHandoverLoading(
      report: currentState.report,
      type: LoadingType.submittingReport,
    ));
    
    try {
      final updatedReport = currentState.report.copyWith(
        summary: event.summary,
        endTime: DateTime.now(),
        isSubmitted: true,
      );

      final submittedReport = await _repository.submitReport(updatedReport);
      emit(ShiftHandoverSuccess(
        report: submittedReport,
        type: SuccessType.reportSubmitted,
      ));
    } catch (e) {
      final exception = e is ShiftHandoverException ? e : null;
      emit(ShiftHandoverError(
        message: exception?.message ?? e.toString(),
        report: currentState.report,
        exception: exception,
      ));
    }
  }

  Future<void> _onRefreshReportRequested(
    RefreshReportRequested event,
    Emitter<ShiftHandoverState> emit,
  ) async {
    final currentState = state;
    final currentReport = currentState is ShiftHandoverSuccess ? currentState.report : null;
    
    emit(ShiftHandoverLoading(
      report: currentReport,
      type: LoadingType.loadingReport,
    ));
    
    try {
      final report = await _repository.getShiftReport(event.caregiverId);
      emit(ShiftHandoverSuccess(
        report: report,
        type: SuccessType.reportLoaded,
      ));
    } catch (e) {
      final exception = e is ShiftHandoverException ? e : null;
      emit(ShiftHandoverError(
        message: exception?.message ?? e.toString(),
        report: currentReport,
        exception: exception,
      ));
    }
  }
} 
