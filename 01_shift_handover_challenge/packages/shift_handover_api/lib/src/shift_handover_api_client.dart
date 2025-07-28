import 'dart:async';

import 'models/handover_note_dto.dart';
import 'models/shift_report_dto.dart';

class ShiftHandoverApiClient {
  final Map<String, ShiftReportDto> _reports = {};
  final Map<String, List<HandoverNoteDto>> _reportNotes = {};

  Future<ShiftReportDto?> getShiftReport(String caregiverId) async {
    await _simulateNetworkDelay();
    
    final reportId = '${caregiverId}_report';
    
    if (!_reports.containsKey(reportId)) {
      final newReport = ShiftReportDto(
        id: reportId,
        caregiverId: caregiverId,
        startTime: DateTime.now().toIso8601String(),
        notes: const [],
        summary: '',
        isSubmitted: false,
      );
      _reports[reportId] = newReport;
      _reportNotes[reportId] = [];
    }
    
    final notes = _reportNotes[reportId] ?? [];
    return _reports[reportId]!.copyWith(notes: notes);
  }

  Future<HandoverNoteDto> addNote(String reportId, HandoverNoteDto note) async {
    await _simulateNetworkDelay();
    
    if (!_reportNotes.containsKey(reportId)) {
      _reportNotes[reportId] = [];
    }
    
    _reportNotes[reportId]!.add(note);
    return note;
  }

  Future<ShiftReportDto> submitReport(ShiftReportDto report) async {
    await _simulateNetworkDelay();
    
    final submittedReport = report.copyWith(
      isSubmitted: true,
      endTime: DateTime.now().toIso8601String(),
    );
    
    _reports[report.id] = submittedReport;
    return submittedReport;
  }

  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(const Duration(seconds: 1));
  }
}

extension ShiftReportDtoExtension on ShiftReportDto {
  ShiftReportDto copyWith({
    String? id,
    String? caregiverId,
    String? startTime,
    String? endTime,
    List<HandoverNoteDto>? notes,
    String? summary,
    bool? isSubmitted,
  }) {
    return ShiftReportDto(
      id: id ?? this.id,
      caregiverId: caregiverId ?? this.caregiverId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      notes: notes ?? this.notes,
      summary: summary ?? this.summary,
      isSubmitted: isSubmitted ?? this.isSubmitted,
    );
  }
}