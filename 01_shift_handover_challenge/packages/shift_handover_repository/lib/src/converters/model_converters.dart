import 'package:shift_handover_api/shift_handover_api.dart';
import '../models/handover_note.dart';
import '../models/shift_report.dart';

class ModelConverters {
  static HandoverNote noteFromDto(HandoverNoteDto dto) {
    return HandoverNote(
      id: dto.id,
      text: dto.text,
      type: _noteTypeFromString(dto.type),
      timestamp: DateTime.parse(dto.timestamp),
      authorId: dto.authorId,
      taggedResidentIds: dto.taggedResidentIds,
      isAcknowledged: dto.isAcknowledged,
    );
  }

  static HandoverNoteDto noteToDto(HandoverNote note) {
    return HandoverNoteDto(
      id: note.id,
      text: note.text,
      type: _noteTypeToString(note.type),
      timestamp: note.timestamp.toIso8601String(),
      authorId: note.authorId,
      taggedResidentIds: note.taggedResidentIds,
      isAcknowledged: note.isAcknowledged,
    );
  }

  static ShiftReport reportFromDto(ShiftReportDto dto) {
    return ShiftReport(
      id: dto.id,
      caregiverId: dto.caregiverId,
      startTime: DateTime.parse(dto.startTime),
      endTime: dto.endTime != null ? DateTime.parse(dto.endTime!) : null,
      notes: dto.notes.map(noteFromDto).toList(),
      summary: dto.summary,
      isSubmitted: dto.isSubmitted,
    );
  }

  static ShiftReportDto reportToDto(ShiftReport report) {
    return ShiftReportDto(
      id: report.id,
      caregiverId: report.caregiverId,
      startTime: report.startTime.toIso8601String(),
      endTime: report.endTime?.toIso8601String(),
      notes: report.notes.map(noteToDto).toList(),
      summary: report.summary,
      isSubmitted: report.isSubmitted,
    );
  }

  static NoteType _noteTypeFromString(String type) {
    switch (type) {
      case 'observation':
        return NoteType.observation;
      case 'incident':
        return NoteType.incident;
      case 'medication':
        return NoteType.medication;
      case 'task':
        return NoteType.task;
      case 'supplyRequest':
        return NoteType.supplyRequest;
      default:
        return NoteType.observation;
    }
  }

  static String _noteTypeToString(NoteType type) {
    switch (type) {
      case NoteType.observation:
        return 'observation';
      case NoteType.incident:
        return 'incident';
      case NoteType.medication:
        return 'medication';
      case NoteType.task:
        return 'task';
      case NoteType.supplyRequest:
        return 'supplyRequest';
    }
  }
}