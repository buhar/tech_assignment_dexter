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
       super(const ShiftHandoverState()) {
    on<LoadShiftReport>(_onLoadShiftReport);
    on<AddNewNote>(_onAddNewNote);
    on<SubmitReport>(_onSubmitReport);
  }

  Future<void> _onLoadShiftReport(
    LoadShiftReport event,
    Emitter<ShiftHandoverState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final report = await _repository.getShiftReport(event.caregiverId);
      emit(state.copyWith(report: report, isLoading: false));
    } catch (e) {
      emit(state.copyWith(
        error: e is ShiftHandoverException ? e.message : e.toString(), 
        isLoading: false,
      ));
    }
  }

  Future<void> _onAddNewNote(
    AddNewNote event,
    Emitter<ShiftHandoverState> emit,
  ) async {
    if (state.report == null) return;

    emit(state.copyWith(isLoading: true, clearError: true));
    
    try {
      final newNote = HandoverNote(
        id: 'note-${DateTime.now().millisecondsSinceEpoch}',
        text: event.text,
        type: event.type,
        timestamp: DateTime.now(),
        authorId: state.report!.caregiverId,
      );

      await _repository.addNote(state.report!.id, newNote);
      
      final updatedNotes = List<HandoverNote>.from(state.report!.notes)..add(newNote);
      final updatedReport = state.report!.copyWith(notes: updatedNotes);
      
      emit(state.copyWith(report: updatedReport, isLoading: false));
    } catch (e) {
      emit(state.copyWith(
        error: e is ShiftHandoverException ? e.message : e.toString(),
        isLoading: false,
      ));
    }
  }

  Future<void> _onSubmitReport(
    SubmitReport event,
    Emitter<ShiftHandoverState> emit,
  ) async {
    if (state.report == null) return;

    emit(state.copyWith(isSubmitting: true, clearError: true));
    try {
      final updatedReport = state.report!.copyWith(
        summary: event.summary,
        endTime: DateTime.now(),
        isSubmitted: true,
      );

      final submittedReport = await _repository.submitReport(updatedReport);
      emit(state.copyWith(report: submittedReport, isSubmitting: false));
    } catch (e) {
      emit(state.copyWith(
        error: e is ShiftHandoverException ? e.message : e.toString(),
        isSubmitting: false,
      ));
    }
  }
} 
