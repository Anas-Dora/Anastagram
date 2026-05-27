/// Wiederverwendbare Exception-Typen für die App
abstract class AppException implements Exception {
  AppException(this.message);
  final String message;

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  NetworkException(String message) : super('Netzwerkfehler: $message');
}

class NotFoundException extends AppException {
  NotFoundException(String message) : super('Nicht gefunden: $message');
}

class ParseException extends AppException {
  ParseException(String message) : super('Datenfehler: $message');
}

class ValidationException extends AppException {
  ValidationException(String message) : super('Ungültige Eingabe: $message');
}

class StorageException extends AppException {
  StorageException(String message) : super('Speicherfehler: $message');
}

