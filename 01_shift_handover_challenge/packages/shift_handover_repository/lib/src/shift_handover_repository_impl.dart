import 'package:shift_handover_api/shift_handover_api.dart';

import 'converters/model_converters.dart';
import 'exceptions/shift_handover_exceptions.dart';
import 'models/handover_note.dart';
import 'models/shift_report.dart';
import 'shift_handover_repository.dart';
import 'storage/in_memory_shift_handover_storage.dart';

class ShiftHandoverRepositoryImpl implements ShiftHandoverRepository {
  final ShiftHandoverApiClient _apiClient;
  final InMemoryShiftHandoverStorage _storage;

  ShiftHandoverRepositoryImpl({
    required ShiftHandoverApiClient apiClient,
    required InMemoryShiftHandoverStorage storage,
  })  : _apiClient = apiClient,
        _storage = storage;

  @override
  Future<ShiftReport> getShiftReport(String caregiverId) async {
    try {
      final reportId = '${caregiverId}_report';
      
      final cachedReport = await _storage.getReport(reportId);
      if (cachedReport != null) {
        return cachedReport;
      }
      
      final reportDto = await _apiClient.getShiftReport(caregiverId);
      if (reportDto == null) {
        throw const LoadShiftReportException('Failed to load shift report');
      }
      
      final report = ModelConverters.reportFromDto(reportDto);
      await _storage.saveReport(report);
      
      return report;
    } catch (e) {
      if (e is ShiftHandoverException) {
        rethrow;
      }
      throw LoadShiftReportException('Failed to load shift report', e);
    }
  }

  @override
  Future<HandoverNote> addNote(String reportId, HandoverNote note) async {
    try {
      final noteDto = ModelConverters.noteToDto(note);
      await _apiClient.addNote(reportId, noteDto);
      
      final addedNote = await _storage.addNote(reportId, note);
      return addedNote;
    } catch (e) {
      if (e is ShiftHandoverException) {
        rethrow;
      }
      throw AddNoteException('Failed to add note', e);
    }
  }

  @override
  Future<ShiftReport> submitReport(ShiftReport report) async {
    try {
      final reportDto = ModelConverters.reportToDto(report);
      final submittedReportDto = await _apiClient.submitReport(reportDto);
      
      final submittedReport = ModelConverters.reportFromDto(submittedReportDto);
      await _storage.saveReport(submittedReport);
      
      return submittedReport;
    } catch (e) {
      if (e is ShiftHandoverException) {
        rethrow;
      }
      throw SubmitReportException('Failed to submit report', e);
    }
  }
}