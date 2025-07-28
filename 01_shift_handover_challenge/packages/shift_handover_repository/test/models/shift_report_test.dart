import 'package:test/test.dart';
import 'package:shift_handover_repository/src/models/handover_note.dart';
import 'package:shift_handover_repository/src/models/shift_report.dart';

void main() {
  group('ShiftReport', () {
    final startTime = DateTime(2023, 12, 1, 8, 0, 0);
    final endTime = DateTime(2023, 12, 1, 16, 0, 0);
    
    final testNote = HandoverNote(
      id: 'note1',
      text: 'Test note',
      type: NoteType.observation,
      timestamp: DateTime(2023, 12, 1, 10, 0, 0),
      authorId: 'caregiver123',
    );

    test('should create ShiftReport with required fields', () {
      final report = ShiftReport(
        id: 'report1',
        caregiverId: 'caregiver123',
        startTime: startTime,
      );

      expect(report.id, equals('report1'));
      expect(report.caregiverId, equals('caregiver123'));
      expect(report.startTime, equals(startTime));
      expect(report.endTime, isNull);
      expect(report.notes, isEmpty);
      expect(report.summary, isEmpty);
      expect(report.isSubmitted, isFalse);
    });

    test('should create ShiftReport with all fields', () {
      final report = ShiftReport(
        id: 'report1',
        caregiverId: 'caregiver123',
        startTime: startTime,
        endTime: endTime,
        notes: [testNote],
        summary: 'Completed all tasks',
        isSubmitted: true,
      );

      expect(report.id, equals('report1'));
      expect(report.caregiverId, equals('caregiver123'));
      expect(report.startTime, equals(startTime));
      expect(report.endTime, equals(endTime));
      expect(report.notes, equals([testNote]));
      expect(report.summary, equals('Completed all tasks'));
      expect(report.isSubmitted, isTrue);
    });

    test('copyWith should create new instance with updated fields', () {
      final original = ShiftReport(
        id: 'report1',
        caregiverId: 'caregiver123',
        startTime: startTime,
      );

      final updated = original.copyWith(
        endTime: endTime,
        notes: [testNote],
        summary: 'Updated summary',
        isSubmitted: true,
      );

      expect(updated.id, equals(original.id));
      expect(updated.caregiverId, equals(original.caregiverId));
      expect(updated.startTime, equals(original.startTime));
      expect(updated.endTime, equals(endTime));
      expect(updated.notes, equals([testNote]));
      expect(updated.summary, equals('Updated summary'));
      expect(updated.isSubmitted, isTrue);
    });

    test('copyWith should preserve original values when no changes provided', () {
      final original = ShiftReport(
        id: 'report1',
        caregiverId: 'caregiver123',
        startTime: startTime,
        endTime: endTime,
        notes: [testNote],
        summary: 'Original summary',
        isSubmitted: true,
      );

      final copy = original.copyWith();

      expect(copy.id, equals(original.id));
      expect(copy.caregiverId, equals(original.caregiverId));
      expect(copy.startTime, equals(original.startTime));
      expect(copy.endTime, equals(original.endTime));
      expect(copy.notes, equals(original.notes));
      expect(copy.summary, equals(original.summary));
      expect(copy.isSubmitted, equals(original.isSubmitted));
    });

    test('should implement Equatable correctly', () {
      final report1 = ShiftReport(
        id: 'report1',
        caregiverId: 'caregiver123',
        startTime: startTime,
        endTime: endTime,
        notes: [testNote],
        summary: 'Test summary',
        isSubmitted: true,
      );

      final report2 = ShiftReport(
        id: 'report1',
        caregiverId: 'caregiver123',
        startTime: startTime,
        endTime: endTime,
        notes: [testNote],
        summary: 'Test summary',
        isSubmitted: true,
      );

      final report3 = ShiftReport(
        id: 'report2',
        caregiverId: 'caregiver123',
        startTime: startTime,
        endTime: endTime,
        notes: [testNote],
        summary: 'Test summary',
        isSubmitted: true,
      );

      expect(report1, equals(report2));
      expect(report1.hashCode, equals(report2.hashCode));
      expect(report1, isNot(equals(report3)));
    });

    test('should have correct props for Equatable', () {
      final report = ShiftReport(
        id: 'report1',
        caregiverId: 'caregiver123',
        startTime: startTime,
        endTime: endTime,
        notes: [testNote],
        summary: 'Test summary',
        isSubmitted: true,
      );

      expect(report.props, equals([
        'report1',
        'caregiver123',
        startTime,
        endTime,
        [testNote],
        'Test summary',
        true,
      ]));
    });

    test('should handle multiple notes', () {
      final note2 = HandoverNote(
        id: 'note2',
        text: 'Second note',
        type: NoteType.medication,
        timestamp: DateTime(2023, 12, 1, 12, 0, 0),
        authorId: 'caregiver123',
      );

      final report = ShiftReport(
        id: 'report1',
        caregiverId: 'caregiver123',
        startTime: startTime,
        notes: [testNote, note2],
      );

      expect(report.notes.length, equals(2));
      expect(report.notes, contains(testNote));
      expect(report.notes, contains(note2));
    });
  });
}