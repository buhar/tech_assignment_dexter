import 'package:equatable/equatable.dart';

enum NoteType {
  observation,
  incident,
  medication,
  task,
  supplyRequest,
}

class HandoverNote extends Equatable {
  final String id;
  final String text;
  final NoteType type;
  final DateTime timestamp;
  final String authorId;
  final List<String> taggedResidentIds;
  final bool isAcknowledged;

  const HandoverNote({
    required this.id,
    required this.text,
    required this.type,
    required this.timestamp,
    required this.authorId,
    this.taggedResidentIds = const [],
    this.isAcknowledged = false,
  });

  HandoverNote copyWith({
    String? id,
    String? text,
    NoteType? type,
    DateTime? timestamp,
    String? authorId,
    List<String>? taggedResidentIds,
    bool? isAcknowledged,
  }) {
    return HandoverNote(
      id: id ?? this.id,
      text: text ?? this.text,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      authorId: authorId ?? this.authorId,
      taggedResidentIds: taggedResidentIds ?? this.taggedResidentIds,
      isAcknowledged: isAcknowledged ?? this.isAcknowledged,
    );
  }

  @override
  List<Object?> get props => [
        id,
        text,
        type,
        timestamp,
        authorId,
        taggedResidentIds,
        isAcknowledged,
      ];
}

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
