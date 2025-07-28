import 'dart:async';
import 'package:test/test.dart';
import 'package:shift_handover_repository/src/models/handover_note.dart';
import 'package:shift_handover_repository/src/models/shift_report.dart';
import 'package:shift_handover_repository/src/storage/in_memory_shift_handover_storage.dart';

void main() {
  group('InMemoryShiftHandoverStorage', () {
    late InMemoryShiftHandoverStorage storage;

    setUp(() {
      storage = InMemoryShiftHandoverStorage();
    });

    tearDown(() {
      storage.dispose();
    });

    final startTime = DateTime(2023, 12, 1, 8, 0, 0);
    final endTime = DateTime(2023, 12, 1, 16, 0, 0);
    final timestamp = DateTime(2023, 12, 1, 10, 0, 0);

    final testNote = HandoverNote(
      id: 'note1',
      text: 'Test note',
      type: NoteType.observation,
      timestamp: timestamp,
      authorId: 'caregiver123',
    );

    final testReport = ShiftReport(
      id: 'report1',
      caregiverId: 'caregiver123',
      startTime: startTime,
      endTime: endTime,
      notes: [testNote],
      summary: 'Test report',
      isSubmitted: false,
    );

    group('getReport', () {
      test('should return null for non-existent report', () async {
        final result = await storage.getReport('non-existent');
        expect(result, isNull);
      });

      test('should return saved report', () async {
        await storage.saveReport(testReport);
        
        final result = await storage.getReport('report1');
        expect(result, equals(testReport));
      });

      test('should return report with correct notes', () async {
        final reportWithoutNotes = testReport.copyWith(notes: []);
        await storage.saveReport(reportWithoutNotes);
        await storage.addNote('report1', testNote);
        
        final result = await storage.getReport('report1');
        expect(result, isNotNull);
        expect(result!.notes.length, equals(1));
        expect(result.notes.first, equals(testNote));
      });
    });

    group('saveReport', () {
      test('should save report successfully', () async {
        final result = await storage.saveReport(testReport);
        expect(result, equals(testReport));
        
        final retrieved = await storage.getReport('report1');
        expect(retrieved, equals(testReport));
      });

      test('should overwrite existing report', () async {
        await storage.saveReport(testReport);
        
        final updatedReport = testReport.copyWith(summary: 'Updated summary');
        await storage.saveReport(updatedReport);
        
        final retrieved = await storage.getReport('report1');
        expect(retrieved, equals(updatedReport));
      });

      test('should emit report on stream', () async {
        final streamFuture = storage.reportStream.first;
        
        await storage.saveReport(testReport);
        
        final emittedReport = await streamFuture;
        expect(emittedReport, equals(testReport));
      });
    });

    group('addNote', () {
      test('should add note to new report', () async {
        final result = await storage.addNote('report1', testNote);
        expect(result, equals(testNote));
        
        final notes = await storage.getNotes('report1');
        expect(notes.length, equals(1));
        expect(notes.first, equals(testNote));
      });

      test('should add note to existing report', () async {
        await storage.saveReport(testReport.copyWith(notes: []));
        
        final result = await storage.addNote('report1', testNote);
        expect(result, equals(testNote));
        
        final notes = await storage.getNotes('report1');
        expect(notes.length, equals(1));
        expect(notes.first, equals(testNote));
      });

      test('should update existing report with new note', () async {
        await storage.saveReport(testReport.copyWith(notes: []));
        
        await storage.addNote('report1', testNote);
        
        final updatedReport = await storage.getReport('report1');
        expect(updatedReport, isNotNull);
        expect(updatedReport!.notes.length, equals(1));
        expect(updatedReport.notes.first, equals(testNote));
      });

      test('should emit updated report on stream when report exists', () async {
        await storage.saveReport(testReport.copyWith(notes: []));
        
        final streamFuture = storage.reportStream.first;
        
        await storage.addNote('report1', testNote);
        
        final emittedReport = await streamFuture;
        expect(emittedReport.notes.length, equals(1));
        expect(emittedReport.notes.first, equals(testNote));
      });

      test('should handle multiple notes', () async {
        final note2 = HandoverNote(
          id: 'note2',
          text: 'Second note',
          type: NoteType.medication,
          timestamp: timestamp,
          authorId: 'caregiver123',
        );

        await storage.addNote('report1', testNote);
        await storage.addNote('report1', note2);
        
        final notes = await storage.getNotes('report1');
        expect(notes.length, equals(2));
        expect(notes, contains(testNote));
        expect(notes, contains(note2));
      });
    });

    group('removeNote', () {
      test('should remove note from report', () async {
        await storage.addNote('report1', testNote);
        
        await storage.removeNote('report1', 'note1');
        
        final notes = await storage.getNotes('report1');
        expect(notes, isEmpty);
      });

      test('should update existing report after removing note', () async {
        await storage.saveReport(testReport);
        
        await storage.removeNote('report1', 'note1');
        
        final updatedReport = await storage.getReport('report1');
        expect(updatedReport, isNotNull);
        expect(updatedReport!.notes, isEmpty);
      });

      test('should emit updated report on stream when report exists', () async {
        await storage.saveReport(testReport);
        
        final streamCompleter = Completer<ShiftReport>();
        final subscription = storage.reportStream.listen((report) {
          if (report.notes.isEmpty) {
            streamCompleter.complete(report);
          }
        });
        
        await storage.removeNote('report1', 'note1');
        
        final emittedReport = await streamCompleter.future;
        expect(emittedReport.notes, isEmpty);
        
        await subscription.cancel();
      });

      test('should handle removing non-existent note', () async {
        await storage.addNote('report1', testNote);
        
        await storage.removeNote('report1', 'non-existent');
        
        final notes = await storage.getNotes('report1');
        expect(notes.length, equals(1));
        expect(notes.first, equals(testNote));
      });

      test('should handle removing note from non-existent report', () async {
        await storage.removeNote('non-existent', 'note1');
        
        final notes = await storage.getNotes('non-existent');
        expect(notes, isEmpty);
      });
    });

    group('getNotes', () {
      test('should return empty list for non-existent report', () async {
        final notes = await storage.getNotes('non-existent');
        expect(notes, isEmpty);
      });

      test('should return notes for existing report', () async {
        await storage.addNote('report1', testNote);
        
        final notes = await storage.getNotes('report1');
        expect(notes.length, equals(1));
        expect(notes.first, equals(testNote));
      });

      test('should return copy of notes list', () async {
        await storage.addNote('report1', testNote);
        
        final notes1 = await storage.getNotes('report1');
        final notes2 = await storage.getNotes('report1');
        
        expect(notes1, isNot(same(notes2)));
        expect(notes1, equals(notes2));
      });
    });

    group('clear', () {
      test('should clear all data', () async {
        await storage.saveReport(testReport);
        await storage.addNote('report2', testNote);
        
        await storage.clear();
        
        final report1 = await storage.getReport('report1');
        final report2 = await storage.getReport('report2');
        final notes2 = await storage.getNotes('report2');
        
        expect(report1, isNull);
        expect(report2, isNull);
        expect(notes2, isEmpty);
      });
    });

    group('reportStream', () {
      test('should be broadcast stream', () {
        expect(storage.reportStream.isBroadcast, isTrue);
      });

      test('should emit reports when saved', () async {
        final reports = <ShiftReport>[];
        final subscription = storage.reportStream.listen(reports.add);
        
        await storage.saveReport(testReport);
        await storage.saveReport(testReport.copyWith(summary: 'Updated'));
        
        await Future.delayed(Duration.zero);
        
        expect(reports.length, equals(2));
        expect(reports[0], equals(testReport));
        expect(reports[1].summary, equals('Updated'));
        
        await subscription.cancel();
      });
    });

    group('dispose', () {
      test('should close stream controller', () async {
        final testStorage = InMemoryShiftHandoverStorage();
        
        testStorage.dispose();
        
        expect(testStorage.reportStream.isBroadcast, isTrue);
      });
    });
  });
}