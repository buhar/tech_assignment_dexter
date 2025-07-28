import 'package:test/test.dart';
import 'package:shift_handover_repository/src/models/handover_note.dart';

void main() {
  group('HandoverNote', () {
    final timestamp = DateTime(2023, 12, 1, 10, 0, 0);
    
    test('should create HandoverNote with required fields', () {
      final note = HandoverNote(
        id: '1',
        text: 'Patient medication administered',
        type: NoteType.medication,
        timestamp: timestamp,
        authorId: 'caregiver123',
      );

      expect(note.id, equals('1'));
      expect(note.text, equals('Patient medication administered'));
      expect(note.type, equals(NoteType.medication));
      expect(note.timestamp, equals(timestamp));
      expect(note.authorId, equals('caregiver123'));
      expect(note.taggedResidentIds, isEmpty);
      expect(note.isAcknowledged, isFalse);
    });

    test('should create HandoverNote with all fields', () {
      final note = HandoverNote(
        id: '1',
        text: 'Patient medication administered',
        type: NoteType.medication,
        timestamp: timestamp,
        authorId: 'caregiver123',
        taggedResidentIds: const ['resident1', 'resident2'],
        isAcknowledged: true,
      );

      expect(note.id, equals('1'));
      expect(note.text, equals('Patient medication administered'));
      expect(note.type, equals(NoteType.medication));
      expect(note.timestamp, equals(timestamp));
      expect(note.authorId, equals('caregiver123'));
      expect(note.taggedResidentIds, equals(['resident1', 'resident2']));
      expect(note.isAcknowledged, isTrue);
    });

    test('should support all note types', () {
      const types = [
        NoteType.observation,
        NoteType.incident,
        NoteType.medication,
        NoteType.task,
        NoteType.supplyRequest,
      ];

      for (final type in types) {
        final note = HandoverNote(
          id: '1',
          text: 'Test note',
          type: type,
          timestamp: timestamp,
          authorId: 'caregiver123',
        );
        expect(note.type, equals(type));
      }
    });

    test('copyWith should create new instance with updated fields', () {
      final original = HandoverNote(
        id: '1',
        text: 'Original text',
        type: NoteType.observation,
        timestamp: timestamp,
        authorId: 'caregiver123',
      );

      final updated = original.copyWith(
        text: 'Updated text',
        type: NoteType.incident,
        isAcknowledged: true,
      );

      expect(updated.id, equals(original.id));
      expect(updated.text, equals('Updated text'));
      expect(updated.type, equals(NoteType.incident));
      expect(updated.timestamp, equals(original.timestamp));
      expect(updated.authorId, equals(original.authorId));
      expect(updated.taggedResidentIds, equals(original.taggedResidentIds));
      expect(updated.isAcknowledged, isTrue);
    });

    test('copyWith should preserve original values when no changes provided', () {
      final original = HandoverNote(
        id: '1',
        text: 'Original text',
        type: NoteType.observation,
        timestamp: timestamp,
        authorId: 'caregiver123',
        taggedResidentIds: const ['resident1'],
        isAcknowledged: true,
      );

      final copy = original.copyWith();

      expect(copy.id, equals(original.id));
      expect(copy.text, equals(original.text));
      expect(copy.type, equals(original.type));
      expect(copy.timestamp, equals(original.timestamp));
      expect(copy.authorId, equals(original.authorId));
      expect(copy.taggedResidentIds, equals(original.taggedResidentIds));
      expect(copy.isAcknowledged, equals(original.isAcknowledged));
    });

    test('should implement Equatable correctly', () {
      final note1 = HandoverNote(
        id: '1',
        text: 'Test note',
        type: NoteType.observation,
        timestamp: timestamp,
        authorId: 'caregiver123',
        taggedResidentIds: const ['resident1'],
        isAcknowledged: true,
      );

      final note2 = HandoverNote(
        id: '1',
        text: 'Test note',
        type: NoteType.observation,
        timestamp: timestamp,
        authorId: 'caregiver123',
        taggedResidentIds: const ['resident1'],
        isAcknowledged: true,
      );

      final note3 = HandoverNote(
        id: '2',
        text: 'Test note',
        type: NoteType.observation,
        timestamp: timestamp,
        authorId: 'caregiver123',
        taggedResidentIds: const ['resident1'],
        isAcknowledged: true,
      );

      expect(note1, equals(note2));
      expect(note1.hashCode, equals(note2.hashCode));
      expect(note1, isNot(equals(note3)));
    });

    test('should have correct props for Equatable', () {
      final note = HandoverNote(
        id: '1',
        text: 'Test note',
        type: NoteType.observation,
        timestamp: timestamp,
        authorId: 'caregiver123',
        taggedResidentIds: const ['resident1'],
        isAcknowledged: true,
      );

      expect(note.props, equals([
        '1',
        'Test note',
        NoteType.observation,
        timestamp,
        'caregiver123',
        ['resident1'],
        true,
      ]));
    });
  });
}