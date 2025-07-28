import 'dart:async';
import '../models/handover_note.dart';
import '../models/shift_report.dart';

class InMemoryShiftHandoverStorage {
  final Map<String, ShiftReport> _reports = {};
  final Map<String, List<HandoverNote>> _reportNotes = {};
  final StreamController<ShiftReport> _reportController = StreamController<ShiftReport>.broadcast();

  Stream<ShiftReport> get reportStream => _reportController.stream;

  Future<ShiftReport?> getReport(String reportId) async {
    if (!_reports.containsKey(reportId)) {
      return null;
    }
    
    final notes = _reportNotes[reportId] ?? [];
    return _reports[reportId]!.copyWith(notes: notes);
  }

  Future<ShiftReport> saveReport(ShiftReport report) async {
    _reports[report.id] = report;
    _reportNotes[report.id] = List.from(report.notes);
    _reportController.add(report);
    return report;
  }

  Future<HandoverNote> addNote(String reportId, HandoverNote note) async {
    if (!_reportNotes.containsKey(reportId)) {
      _reportNotes[reportId] = [];
    }
    
    _reportNotes[reportId]!.add(note);
    
    if (_reports.containsKey(reportId)) {
      final updatedReport = _reports[reportId]!.copyWith(
        notes: List.from(_reportNotes[reportId]!),
      );
      _reports[reportId] = updatedReport;
      _reportController.add(updatedReport);
    }
    
    return note;
  }

  Future<void> removeNote(String reportId, String noteId) async {
    if (_reportNotes.containsKey(reportId)) {
      _reportNotes[reportId]!.removeWhere((note) => note.id == noteId);
      
      if (_reports.containsKey(reportId)) {
        final updatedReport = _reports[reportId]!.copyWith(
          notes: List.from(_reportNotes[reportId]!),
        );
        _reports[reportId] = updatedReport;
        _reportController.add(updatedReport);
      }
    }
  }

  Future<List<HandoverNote>> getNotes(String reportId) async {
    return List.from(_reportNotes[reportId] ?? []);
  }

  Future<void> clear() async {
    _reports.clear();
    _reportNotes.clear();
  }

  void dispose() {
    _reportController.close();
  }
}