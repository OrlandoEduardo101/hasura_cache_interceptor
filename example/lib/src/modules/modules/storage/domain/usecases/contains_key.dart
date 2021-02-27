import 'package:dartz/dartz.dart';
import '../errors/erros.dart';
import '../repositories/storage_repository.dart';

abstract class IContainsKey {
  Future<Either<ReadError, bool>> call(String key);
}

class ContainsKey implements IContainsKey {
  final IStorageRepository _repository;

  ContainsKey(this._repository);

  @override
  Future<Either<ReadError, bool>> call(String key) async {
    // ignore: unnecessary_null_comparison
    if (key == null || key.isEmpty) {
      return Left(ReadError(message: 'Invalid key'));
    }
    return await _repository.containsKey(key);
  }
}