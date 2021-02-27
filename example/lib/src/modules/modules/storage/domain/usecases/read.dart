

import 'package:dartz/dartz.dart';
import '../errors/erros.dart';
import '../repositories/storage_repository.dart';

abstract class IRead {
  Future<Either<ReadError, Map>> call(String key);
}

class Read implements IRead {
  final IStorageRepository _repository;

  Read(this._repository);

  @override
  Future<Either<ReadError, Map>> call(String key) async {
    // ignore: unnecessary_null_comparison
    if (key == null || key.isEmpty) {
      return Left(ReadError(message: 'Invalid key'));
    }
    return await _repository.read(key);
  }
}