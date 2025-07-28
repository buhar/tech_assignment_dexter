import 'package:equatable/equatable.dart';
import 'handover_note.dart';

class ShiftReport extends Equatable {
  final String id;
  final String caregiverId;
  final DateTime startTime;
  final DateTime? endTime;
  final List<HandoverNote> notes;
  final String summary;
  final bool isSubmitted;

  const ShiftReport({
    required this.id,
    required this.caregiverId,
    required this.startTime,
    this.endTime,
    this.notes = const [],
    this.summary = '',
    this.isSubmitted = false,
  });

  ShiftReport copyWith({
    String? id,
    String? caregiverId,
    DateTime? startTime,
    DateTime? endTime,
    List<HandoverNote>? notes,
    String? summary,
    bool? isSubmitted,
  }) {
    return ShiftReport(
      id: id ?? this.id,
      caregiverId: caregiverId ?? this.caregiverId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      notes: notes ?? this.notes,
      summary: summary ?? this.summary,
      isSubmitted: isSubmitted ?? this.isSubmitted,
    );
  }

  @override
  List<Object?> get props => [
        id,
        caregiverId,
        startTime,
        endTime,
        notes,
        summary,
        isSubmitted,
      ];
}