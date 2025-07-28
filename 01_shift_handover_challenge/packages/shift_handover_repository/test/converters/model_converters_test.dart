import 'package:test/test.dart';
import 'package:shift_handover_api/shift_handover_api.dart';
import 'package:shift_handover_repository/src/converters/model_converters.dart';
import 'package:shift_handover_repository/src/models/handover_note.dart';
import 'package:shift_handover_repository/src/models/shift_report.dart';

void main() {
  group('ModelConverters', () {
    final timestamp = DateTime(2023, 12, 1, 10, 0, 0);
    final startTime = DateTime(2023, 12, 1, 8, 0, 0);
    final endTime = DateTime(2023, 12, 1, 16, 0, 0);

    group('noteFromDto', () {
      test('should convert HandoverNoteDto to HandoverNote correctly', () {
        final dto = HandoverNoteDto(
          id: 'note1',
          text: 'Patient medication administered',
          type: 'medication',
          timestamp: timestamp.toIso8601String(),
          authorId: 'caregiver123',
          taggedResidentIds: ['resident1', 'resident2'],
          isAcknowledged: true,
        );

        final note = ModelConverters.noteFromDto(dto);

        expect(note.id, equals('note1'));
        expect(note.text, equals('Patient medication administered'));
        expect(note.type, equals(NoteType.medication));
        expect(note.timestamp, equals(timestamp));
        expect(note.authorId, equals('caregiver123'));
        expect(note.taggedResidentIds, equals(['resident1', 'resident2']));
        expect(note.isAcknowledged, isTrue);
      });

      test('should handle all note types', () {
        final typeMap = {
          'observation': NoteType.observation,
          'incident': NoteType.incident,
          'medication': NoteType.medication,
          'task': NoteType.task,
          'supplyRequest': NoteType.supplyRequest,
        };

        for (final entry in typeMap.entries) {
          final dto = HandoverNoteDto(
            id: 'note1',
            text: 'Test note',
            type: entry.key,
            timestamp: timestamp.toIso8601String(),
            authorId: 'caregiver123',
            taggedResidentIds: [],
            isAcknowledged: false,
          );

          final note = ModelConverters.noteFromDto(dto);
          expect(note.type, equals(entry.value));
        }
      });

      test('should default to observation for unknown note type', () {
        final dto = HandoverNoteDto(
          id: 'note1',
          text: 'Test note',
          type: 'unknown_type',
          timestamp: timestamp.toIso8601String(),
          authorId: 'caregiver123',
          taggedResidentIds: [],
          isAcknowledged: false,
        );

        final note = ModelConverters.noteFromDto(dto);
        expect(note.type, equals(NoteType.observation));
      });
    });

    group('noteToDto', () {
      test('should convert HandoverNote to HandoverNoteDto correctly', () {
        final note = HandoverNote(
          id: 'note1',
          text: 'Patient medication administered',
          type: NoteType.medication,
          timestamp: timestamp,
          authorId: 'caregiver123',
          taggedResidentIds: const ['resident1', 'resident2'],
          isAcknowledged: true,
        );

        final dto = ModelConverters.noteToDto(note);

        expect(dto.id, equals('note1'));
        expect(dto.text, equals('Patient medication administered'));
        expect(dto.type, equals('medication'));
        expect(dto.timestamp, equals(timestamp.toIso8601String()));
        expect(dto.authorId, equals('caregiver123'));
        expect(dto.taggedResidentIds, equals(['resident1', 'resident2']));
        expect(dto.isAcknowledged, isTrue);
      });

      test('should handle all note types', () {
        final typeMap = {
          NoteType.observation: 'observation',
          NoteType.incident: 'incident',
          NoteType.medication: 'medication',
          NoteType.task: 'task',
          NoteType.supplyRequest: 'supplyRequest',
        };

        for (final entry in typeMap.entries) {
          final note = HandoverNote(
            id: 'note1',
            text: 'Test note',
            type: entry.key,
            timestamp: timestamp,
            authorId: 'caregiver123',
          );

          final dto = ModelConverters.noteToDto(note);
          expect(dto.type, equals(entry.value));
        }
      });
    });

    group('reportFromDto', () {
      test('should convert ShiftReportDto to ShiftReport correctly', () {
        final noteDto = HandoverNoteDto(
          id: 'note1',
          text: 'Test note',
          type: 'observation',
          timestamp: timestamp.toIso8601String(),
          authorId: 'caregiver123',
          taggedResidentIds: [],
          isAcknowledged: false,
        );

        final dto = ShiftReportDto(
          id: 'report1',
          caregiverId: 'caregiver123',
          startTime: startTime.toIso8601String(),
          endTime: endTime.toIso8601String(),
          notes: [noteDto],
          summary: 'Shift completed successfully',
          isSubmitted: true,
        );

        final report = ModelConverters.reportFromDto(dto);

        expect(report.id, equals('report1'));
        expect(report.caregiverId, equals('caregiver123'));
        expect(report.startTime, equals(startTime));
        expect(report.endTime, equals(endTime));
        expect(report.notes.length, equals(1));
        expect(report.notes.first.id, equals('note1'));
        expect(report.summary, equals('Shift completed successfully'));
        expect(report.isSubmitted, isTrue);
      });

      test('should handle null endTime', () {
        final dto = ShiftReportDto(
          id: 'report1',
          caregiverId: 'caregiver123',
          startTime: startTime.toIso8601String(),
          endTime: null,
          notes: [],
          summary: '',
          isSubmitted: false,
        );

        final report = ModelConverters.reportFromDto(dto);

        expect(report.endTime, isNull);
      });

      test('should handle empty notes list', () {
        final dto = ShiftReportDto(
          id: 'report1',
          caregiverId: 'caregiver123',
          startTime: startTime.toIso8601String(),
          endTime: null,
          notes: [],
          summary: '',
          isSubmitted: false,
        );

        final report = ModelConverters.reportFromDto(dto);

        expect(report.notes, isEmpty);
      });
    });

    group('reportToDto', () {
      test('should convert ShiftReport to ShiftReportDto correctly', () {
        final note = HandoverNote(
          id: 'note1',
          text: 'Test note',
          type: NoteType.observation,
          timestamp: timestamp,
          authorId: 'caregiver123',
        );

        final report = ShiftReport(
          id: 'report1',
          caregiverId: 'caregiver123',
          startTime: startTime,
          endTime: endTime,
          notes: [note],
          summary: 'Shift completed successfully',
          isSubmitted: true,
        );

        final dto = ModelConverters.reportToDto(report);

        expect(dto.id, equals('report1'));
        expect(dto.caregiverId, equals('caregiver123'));
        expect(dto.startTime, equals(startTime.toIso8601String()));
        expect(dto.endTime, equals(endTime.toIso8601String()));
        expect(dto.notes.length, equals(1));
        expect(dto.notes.first.id, equals('note1'));
        expect(dto.summary, equals('Shift completed successfully'));
        expect(dto.isSubmitted, isTrue);
      });

      test('should handle null endTime', () {
        final report = ShiftReport(
          id: 'report1',
          caregiverId: 'caregiver123',
          startTime: startTime,
          endTime: null,
        );

        final dto = ModelConverters.reportToDto(report);

        expect(dto.endTime, isNull);
      });

      test('should handle empty notes list', () {
        final report = ShiftReport(
          id: 'report1',
          caregiverId: 'caregiver123',
          startTime: startTime,
        );

        final dto = ModelConverters.reportToDto(report);

        expect(dto.notes, isEmpty);
      });
    });

    group('round-trip conversion', () {
      test('should maintain data integrity for note conversion', () {
        final originalNote = HandoverNote(
          id: 'note1',
          text: 'Patient medication administered',
          type: NoteType.medication,
          timestamp: timestamp,
          authorId: 'caregiver123',
          taggedResidentIds: const ['resident1', 'resident2'],
          isAcknowledged: true,
        );

        final dto = ModelConverters.noteToDto(originalNote);
        final convertedNote = ModelConverters.noteFromDto(dto);

        expect(convertedNote, equals(originalNote));
      });

      test('should maintain data integrity for report conversion', () {
        final note = HandoverNote(
          id: 'note1',
          text: 'Test note',
          type: NoteType.observation,
          timestamp: timestamp,
          authorId: 'caregiver123',
        );

        final originalReport = ShiftReport(
          id: 'report1',
          caregiverId: 'caregiver123',
          startTime: startTime,
          endTime: endTime,
          notes: [note],
          summary: 'Shift completed successfully',
          isSubmitted: true,
        );

        final dto = ModelConverters.reportToDto(originalReport);
        final convertedReport = ModelConverters.reportFromDto(dto);

        expect(convertedReport, equals(originalReport));
      });
    });
  });
}