abstract class ShiftHandoverException implements Exception {
  final String message;
  final Object? cause;

  const ShiftHandoverException(this.message, [this.cause]);

  @override
  String toString() => '$runtimeType: $message';
}

class LoadShiftReportException extends ShiftHandoverException {
  const LoadShiftReportException(super.message, [super.cause]);
}

class AddNoteException extends ShiftHandoverException {
  const AddNoteException(super.message, [super.cause]);
}

class SubmitReportException extends ShiftHandoverException {
  const SubmitReportException(super.message, [super.cause]);
}

class NetworkException extends ShiftHandoverException {
  const NetworkException(super.message, [super.cause]);
}