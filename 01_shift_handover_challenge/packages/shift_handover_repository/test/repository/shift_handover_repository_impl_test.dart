import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shift_handover_api/shift_handover_api.dart';
import 'package:shift_handover_repository/src/exceptions/shift_handover_exceptions.dart';
import 'package:shift_handover_repository/src/models/handover_note.dart';
import 'package:shift_handover_repository/src/models/shift_report.dart';
import 'package:shift_handover_repository/src/shift_handover_repository_impl.dart';
import 'package:shift_handover_repository/src/storage/in_memory_shift_handover_storage.dart';

class MockShiftHandoverApiClient extends Mock implements ShiftHandoverApiClient {}

class FakeHandoverNoteDto extends Fake implements HandoverNoteDto {}

class FakeShiftReportDto extends Fake implements ShiftReportDto {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeHandoverNoteDto());
    registerFallbackValue(FakeShiftReportDto());
  });

  group('ShiftHandoverRepositoryImpl', () {
    late MockShiftHandoverApiClient mockApiClient;
    late InMemoryShiftHandoverStorage storage;
    late ShiftHandoverRepositoryImpl repository;

    setUp(() {
      mockApiClient = MockShiftHandoverApiClient();
      storage = InMemoryShiftHandoverStorage();
      repository = ShiftHandoverRepositoryImpl(
        apiClient: mockApiClient,
        storage: storage,
      );
    });

    tearDown(() {
      storage.dispose();
    });

    final startTime = DateTime(2023, 12, 1, 8, 0, 0);
    final endTime = DateTime(2023, 12, 1, 16, 0, 0);
    final timestamp = DateTime(2023, 12, 1, 10, 0, 0);

    final testNoteDto = HandoverNoteDto(
      id: 'note1',
      text: 'Test note',
      type: 'observation',
      timestamp: timestamp.toIso8601String(),
      authorId: 'caregiver123',
      taggedResidentIds: [],
      isAcknowledged: false,
    );

    final testReportDto = ShiftReportDto(
      id: 'caregiver123_report',
      caregiverId: 'caregiver123',
      startTime: startTime.toIso8601String(),
      endTime: endTime.toIso8601String(),
      notes: [testNoteDto],
      summary: 'Test report',
      isSubmitted: false,
    );

    final testNote = HandoverNote(
      id: 'note1',
      text: 'Test note',
      type: NoteType.observation,
      timestamp: timestamp,
      authorId: 'caregiver123',
    );

    final testReport = ShiftReport(
      id: 'caregiver123_report',
      caregiverId: 'caregiver123',
      startTime: startTime,
      endTime: endTime,
      notes: [testNote],
      summary: 'Test report',
      isSubmitted: false,
    );

    group('getShiftReport', () {
      test('should return cached report when available', () async {
        await storage.saveReport(testReport);

        final result = await repository.getShiftReport('caregiver123');

        expect(result, equals(testReport));
        verifyNever(() => mockApiClient.getShiftReport(any()));
      });

      test('should fetch from API and cache when not in storage', () async {
        when(() => mockApiClient.getShiftReport('caregiver123'))
            .thenAnswer((_) async => testReportDto);

        final result = await repository.getShiftReport('caregiver123');

        expect(result.id, equals('caregiver123_report'));
        expect(result.caregiverId, equals('caregiver123'));
        expect(result.notes.length, equals(1));
        
        verify(() => mockApiClient.getShiftReport('caregiver123')).called(1);
        
        final cachedReport = await storage.getReport('caregiver123_report');
        expect(cachedReport, isNotNull);
      });

      test('should throw LoadShiftReportException when API returns null', () async {
        when(() => mockApiClient.getShiftReport('caregiver123'))
            .thenAnswer((_) async => null);

        expect(
          () => repository.getShiftReport('caregiver123'),
          throwsA(isA<LoadShiftReportException>()),
        );
      });

      test('should wrap non-ShiftHandoverException in LoadShiftReportException', () async {
        when(() => mockApiClient.getShiftReport('caregiver123'))
            .thenThrow(Exception('Network error'));

        expect(
          () => repository.getShiftReport('caregiver123'),
          throwsA(
            predicate<LoadShiftReportException>((e) =>
                e.message == 'Failed to load shift report' &&
                e.cause is Exception),
          ),
        );
      });

      test('should rethrow ShiftHandoverException as-is', () async {
        const networkException = NetworkException('Network failed');
        when(() => mockApiClient.getShiftReport('caregiver123'))
            .thenThrow(networkException);

        expect(
          () => repository.getShiftReport('caregiver123'),
          throwsA(equals(networkException)),
        );
      });
    });

    group('addNote', () {
      test('should add note successfully', () async {
        when(() => mockApiClient.addNote('report1', any()))
            .thenAnswer((_) async => testNoteDto);

        final result = await repository.addNote('report1', testNote);

        expect(result, equals(testNote));
        verify(() => mockApiClient.addNote('report1', any())).called(1);
        
        final storageNotes = await storage.getNotes('report1');
        expect(storageNotes, contains(testNote));
      });

      test('should convert note to DTO for API call', () async {
        HandoverNoteDto? capturedDto;
        when(() => mockApiClient.addNote('report1', any()))
            .thenAnswer((invocation) async {
              capturedDto = invocation.positionalArguments[1] as HandoverNoteDto;
              return capturedDto!;
            });

        await repository.addNote('report1', testNote);

        expect(capturedDto, isNotNull);
        expect(capturedDto!.id, equals(testNote.id));
        expect(capturedDto!.text, equals(testNote.text));
        expect(capturedDto!.type, equals('observation'));
      });

      test('should wrap non-ShiftHandoverException in AddNoteException', () async {
        when(() => mockApiClient.addNote('report1', any()))
            .thenThrow(Exception('API error'));

        expect(
          () => repository.addNote('report1', testNote),
          throwsA(
            predicate<AddNoteException>((e) =>
                e.message == 'Failed to add note' &&
                e.cause is Exception),
          ),
        );
      });

      test('should rethrow ShiftHandoverException as-is', () async {
        const networkException = NetworkException('Network failed');
        when(() => mockApiClient.addNote('report1', any()))
            .thenThrow(networkException);

        expect(
          () => repository.addNote('report1', testNote),
          throwsA(equals(networkException)),
        );
      });
    });

    group('submitReport', () {
      test('should submit report successfully', () async {
        final submittedReportDto = testReportDto.copyWith(isSubmitted: true);
        when(() => mockApiClient.submitReport(any()))
            .thenAnswer((_) async => submittedReportDto);

        final result = await repository.submitReport(testReport);

        expect(result.isSubmitted, isTrue);
        verify(() => mockApiClient.submitReport(any())).called(1);
        
        final cachedReport = await storage.getReport(testReport.id);
        expect(cachedReport, isNotNull);
        expect(cachedReport!.isSubmitted, isTrue);
      });

      test('should convert report to DTO for API call', () async {
        ShiftReportDto? capturedDto;
        when(() => mockApiClient.submitReport(any()))
            .thenAnswer((invocation) async {
              capturedDto = invocation.positionalArguments[0] as ShiftReportDto;
              return capturedDto!.copyWith(isSubmitted: true);
            });

        await repository.submitReport(testReport);

        expect(capturedDto, isNotNull);
        expect(capturedDto!.id, equals(testReport.id));
        expect(capturedDto!.caregiverId, equals(testReport.caregiverId));
        expect(capturedDto!.summary, equals(testReport.summary));
        expect(capturedDto!.notes.length, equals(1));
      });

      test('should wrap non-ShiftHandoverException in SubmitReportException', () async {
        when(() => mockApiClient.submitReport(any()))
            .thenThrow(Exception('API error'));

        expect(
          () => repository.submitReport(testReport),
          throwsA(
            predicate<SubmitReportException>((e) =>
                e.message == 'Failed to submit report' &&
                e.cause is Exception),
          ),
        );
      });

      test('should rethrow ShiftHandoverException as-is', () async {
        const networkException = NetworkException('Network failed');
        when(() => mockApiClient.submitReport(any()))
            .thenThrow(networkException);

        expect(
          () => repository.submitReport(testReport),
          throwsA(equals(networkException)),
        );
      });
    });

    group('integration tests', () {
      test('should handle complete workflow: get report, add note, submit', () async {
        when(() => mockApiClient.getShiftReport('caregiver123'))
            .thenAnswer((_) async => testReportDto.copyWith(notes: []));
        when(() => mockApiClient.addNote(any(), any()))
            .thenAnswer((_) async => testNoteDto);
        when(() => mockApiClient.submitReport(any()))
            .thenAnswer((_) async => testReportDto.copyWith(
              notes: [testNoteDto],
              isSubmitted: true,
            ));

        final initialReport = await repository.getShiftReport('caregiver123');
        expect(initialReport.notes, isEmpty);

        await repository.addNote(initialReport.id, testNote);
        final reportWithNotes = await storage.getReport(initialReport.id);
        expect(reportWithNotes!.notes.length, equals(1));

        final submittedReport = await repository.submitReport(reportWithNotes);
        expect(submittedReport.isSubmitted, isTrue);
        expect(submittedReport.notes.length, equals(1));

        verify(() => mockApiClient.getShiftReport('caregiver123')).called(1);
        verify(() => mockApiClient.addNote(any(), any())).called(1);
        verify(() => mockApiClient.submitReport(any())).called(1);
      });

      test('should use cached data after initial API call', () async {
        when(() => mockApiClient.getShiftReport('caregiver123'))
            .thenAnswer((_) async => testReportDto);

        final report1 = await repository.getShiftReport('caregiver123');
        final report2 = await repository.getShiftReport('caregiver123');

        expect(report1, equals(report2));
        verify(() => mockApiClient.getShiftReport('caregiver123')).called(1);
      });
    });
  });
}