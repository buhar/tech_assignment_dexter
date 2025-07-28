import 'models/handover_note.dart';
import 'models/shift_report.dart';

abstract class ShiftHandoverRepository {
  Future<ShiftReport> getShiftReport(String caregiverId);
  Future<HandoverNote> addNote(String reportId, HandoverNote note);
  Future<ShiftReport> submitReport(ShiftReport report);
}