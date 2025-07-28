import 'package:test/test.dart';
import 'package:shift_handover_repository/src/exceptions/shift_handover_exceptions.dart';

void main() {
  group('ShiftHandoverException', () {
    test('should create exception with message', () {
      const exception = LoadShiftReportException('Failed to load report');
      
      expect(exception.message, equals('Failed to load report'));
      expect(exception.cause, isNull);
      expect(exception.toString(), equals('LoadShiftReportException: Failed to load report'));
    });

    test('should create exception with message and cause', () {
      final cause = Exception('Network error');
      final exception = LoadShiftReportException('Failed to load report', cause);
      
      expect(exception.message, equals('Failed to load report'));
      expect(exception.cause, equals(cause));
      expect(exception.toString(), equals('LoadShiftReportException: Failed to load report'));
    });
  });

  group('LoadShiftReportException', () {
    test('should create LoadShiftReportException', () {
      const exception = LoadShiftReportException('Failed to load report');
      
      expect(exception, isA<ShiftHandoverException>());
      expect(exception.message, equals('Failed to load report'));
      expect(exception.toString(), contains('LoadShiftReportException'));
    });

    test('should create LoadShiftReportException with cause', () {
      final cause = Exception('Network timeout');
      final exception = LoadShiftReportException('Failed to load report', cause);
      
      expect(exception, isA<ShiftHandoverException>());
      expect(exception.message, equals('Failed to load report'));
      expect(exception.cause, equals(cause));
    });
  });

  group('AddNoteException', () {
    test('should create AddNoteException', () {
      const exception = AddNoteException('Failed to add note');
      
      expect(exception, isA<ShiftHandoverException>());
      expect(exception.message, equals('Failed to add note'));
      expect(exception.toString(), contains('AddNoteException'));
    });

    test('should create AddNoteException with cause', () {
      final cause = Exception('Validation error');
      final exception = AddNoteException('Failed to add note', cause);
      
      expect(exception, isA<ShiftHandoverException>());
      expect(exception.message, equals('Failed to add note'));
      expect(exception.cause, equals(cause));
    });
  });

  group('SubmitReportException', () {
    test('should create SubmitReportException', () {
      const exception = SubmitReportException('Failed to submit report');
      
      expect(exception, isA<ShiftHandoverException>());
      expect(exception.message, equals('Failed to submit report'));
      expect(exception.toString(), contains('SubmitReportException'));
    });

    test('should create SubmitReportException with cause', () {
      final cause = Exception('Server error');
      final exception = SubmitReportException('Failed to submit report', cause);
      
      expect(exception, isA<ShiftHandoverException>());
      expect(exception.message, equals('Failed to submit report'));
      expect(exception.cause, equals(cause));
    });
  });

  group('NetworkException', () {
    test('should create NetworkException', () {
      const exception = NetworkException('Network connection failed');
      
      expect(exception, isA<ShiftHandoverException>());
      expect(exception.message, equals('Network connection failed'));
      expect(exception.toString(), contains('NetworkException'));
    });

    test('should create NetworkException with cause', () {
      final cause = Exception('Connection timeout');
      final exception = NetworkException('Network connection failed', cause);
      
      expect(exception, isA<ShiftHandoverException>());
      expect(exception.message, equals('Network connection failed'));
      expect(exception.cause, equals(cause));
    });
  });

  group('Exception hierarchy', () {
    test('all exceptions should extend ShiftHandoverException', () {
      const loadException = LoadShiftReportException('Load error');
      const addException = AddNoteException('Add error');
      const submitException = SubmitReportException('Submit error');
      const networkException = NetworkException('Network error');

      expect(loadException, isA<ShiftHandoverException>());
      expect(addException, isA<ShiftHandoverException>());
      expect(submitException, isA<ShiftHandoverException>());
      expect(networkException, isA<ShiftHandoverException>());
    });

    test('all exceptions should implement Exception', () {
      const loadException = LoadShiftReportException('Load error');
      const addException = AddNoteException('Add error');
      const submitException = SubmitReportException('Submit error');
      const networkException = NetworkException('Network error');

      expect(loadException, isA<Exception>());
      expect(addException, isA<Exception>());
      expect(submitException, isA<Exception>());
      expect(networkException, isA<Exception>());
    });
  });
}