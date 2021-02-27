abstract class FailureStorage implements Exception {
  final String? message;

  FailureStorage(this.message);
}

class DeleteError implements FailureStorage {
  final String? message;
  DeleteError({this.message});
}

class PutError implements FailureStorage {
  final String? message;
  PutError({this.message});
}

class UpdateError implements FailureStorage {
  final String? message;
  UpdateError({this.message});
}

class ReadError implements FailureStorage {
  final String? message;
  ReadError({this.message});
}