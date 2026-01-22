// Simple Failure class used across the domain layer
class Failure {
  final String message;
  Failure(this.message);

  @override
  String toString() => 'Failure: $message';
}

